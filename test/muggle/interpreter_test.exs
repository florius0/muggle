defmodule Muggle.InterpreterTest do
  use ExUnit.Case
  doctest Muggle.Expression

  defmodule Expression do
    use Muggle.Expression
  end

  defmodule AnotherExpression do
    use Muggle.Expression

    def validate_argument(x, _, _) when is_atom(x), do: {:ok, x}
    def validate_argument(_, _, _), do: {:error, Muggle.ExpressionTest.error_msg()}
  end

  defmodule Interpreter do
    use Muggle.Interpreter

    def run_expression(%Expression{args: args}, _, _), do: {:ok, args}

    def run_expression(%AnotherExpression{args: [atom1, atom2, atom3] = args}, _, _)
        when is_atom(atom1) and is_atom(atom2) and is_atom(atom3),
        do: {:ok, Enum.map(args, &Atom.to_string/1)}

    def run_expression(%AnotherExpression{args: args}, _, _),
      do: {:error, {AnotherExprssion, args, :some_argument_is_not_an_atom}}
  end

  test "Default implentation of interpreter runs simple expressions" do
    assert Interpreter.run(Expression.new([1, 2, 3]), []) == {:ok, [1, 2, 3]}

    assert Interpreter.run(AnotherExpression.new([:atom, :atom, :atom]), []) ==
             {:ok, ["atom", "atom", "atom"]}
  end

  test "Default implementation handles errors in simpple expressions" do
    assert Interpreter.run(AnotherExpression.new([:atom, :atom, "not_an_atom"]), []) ==
             {:error,
              {AnotherExprssion, [:atom, :atom, "not_an_atom"], :some_argument_is_not_an_atom}}
  end

  test "Default implentation of interpreter runs nested expressions" do
    assert Interpreter.run(
             Expression.new([1, 2, AnotherExpression.new([:atom, :atom, :atom])]),
             []
           ) == {:ok, [1, 2, ["atom", "atom", "atom"]]}
  end

  test "Default implementation of interpreter handles errors in neseted expressions" do
    assert Interpreter.run(
             Expression.new([1, 2, AnotherExpression.new([:atom, :atom, "not_an_atom"])]),
             []
           ) ==
             {
               :error,
               {Muggle.InterpreterTest.Expression,
                [
                  ok: 1,
                  ok: 2,
                  error:
                    {AnotherExprssion, [:atom, :atom, "not_an_atom"],
                     :some_argument_is_not_an_atom}
                ]}
             }

    assert Interpreter.run(
             AnotherExpression.new([
               :atom,
               :atom,
               AnotherExpression.new([:atom, :atom, "not_an_atom"])
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
                     {AnotherExprssion, [:atom, :atom, "not_an_atom"],
                      :some_argument_is_not_an_atom}
                 ]
               }
             }
  end
end
