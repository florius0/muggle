defmodule Muggle.InterpreterTest do
  use ExUnit.Case
  doctest Muggle.Expression

  defmodule Expression do
    use Muggle.Expression
  end

  defmodule AnotherExpression do
    use Muggle.Expression

    def validate_argument(x, _, _) when is_atom(x), do: {:ok, x}
    def validate_argument(x, _, _) when is_struct(x), do: {:ok, x}
    def validate_argument(_, _, _), do: {:error, :unsupported_type}
  end

  defmodule Interpreter do
    use Muggle.Interpreter

    def run_expression(%Expression{args: args}, _, _), do: {:ok, args}

    def run_expression(%AnotherExpression{args: [_, _, _] = args}, _, _),
      do: {:ok, Enum.map(args, &Atom.to_string/1)}

    def run_expression(%AnotherExpression{args: args}, _, _),
      do: {:error, {AnotherExprssion, args, :supports_only_3_args_due_to_bad_programming_skills}}
  end

  test "Default implentation of interpreter runs simple expressions" do
    assert Interpreter.run(Expression.new([1, 2, 3]), []) == {:ok, [1, 2, 3]}

    assert Interpreter.run(AnotherExpression.new([:atom, :atom, :atom]), []) ==
             {:ok, ["atom", "atom", "atom"]}
  end

  test "Default implementation handles errors in simple expressions" do
    assert Interpreter.run(AnotherExpression.new([:atom, :atom]), []) ==
             {:error,
              {AnotherExprssion, [:atom, :atom],
               :supports_only_3_args_due_to_bad_programming_skills}}
  end

  test "Default implentation of interpreter runs nested expressions" do
    assert Interpreter.run(
             Expression.new([1, 2, AnotherExpression.new([:atom, :atom, :atom])]),
             []
           ) == {:ok, [1, 2, ["atom", "atom", "atom"]]}
  end

  test "Default implementation of interpreter handles erors in neseted expressions" do
    assert Interpreter.run(
             Expression.new([1, 2, AnotherExpression.new([:atom, :atom])]),
             []
           ) ==
             {
               :error,
               {Muggle.InterpreterTest.Expression,
                [
                  ok: 1,
                  ok: 2,
                  error:
                    {AnotherExprssion, [:atom, :atom],
                     :supports_only_3_args_due_to_bad_programming_skills}
                ]}
             }

    assert Interpreter.run(
             AnotherExpression.new([
               :atom,
               :atom,
               AnotherExpression.new([:atom, :atom])
             ]),
             []
           ) ==
             {
               :error,
               {
                 Muggle.InterpreterTest.AnotherExpression,
                 [
                   ok: :atom,
                   ok: :atom,
                   error:
                     {AnotherExprssion, [:atom, :atom],
                      :supports_only_3_args_due_to_bad_programming_skills}
                 ]
               }
             }
  end

  test "Default implementation of interpreter validates expressions" do
    assert Interpreter.run(AnotherExpression.new(["not_an_atom"]), []) == {:error, {Muggle.InterpreterTest.AnotherExpression, [error: :unsupported_type]}}
  end
end
