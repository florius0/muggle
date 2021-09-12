defmodule Muggle.ExpressionTest do
  use ExUnit.Case
  doctest Muggle.Expression

  @error_msg "unsupported type"

  defmodule Expression do
    use Muggle.Expression
  end

  defmodule AnotherExpression do
    use Muggle.Expression

    def validate_argument(x, _, _) when is_atom(x), do: {:ok, x}
    def validate_argument(_, _, _), do: {:error, Muggle.ExpressionTest.error_msg()}
  end

  describe "creation" do
    test "Default implementation of new/1 creates new Expression structure" do
      assert %Expression{args: []} == Expression.new([])
    end

    test "Default implementation of new/1 puts all arguments to struct" do
      assert %Expression{args: [:first, :second, :etc]} == Expression.new([:first, :second, :etc])
    end

    test "Default implementation of new/0 returns empty args list" do
      assert %Expression{args: []} == Expression.new()
    end
  end

  describe "validation" do
    test "Default implementation of validate returns {:ok, expr}" do
      assert {:ok, Expression.new()} == Expression.validate(Expression.new())
    end

    test "Default implementation of validate returns {:ok, expr} if all validate_argument/3 returns {:ok, arg}" do
      assert {:ok, AnotherExpression.new([:atom])} ==
               AnotherExpression.validate(AnotherExpression.new([:atom]))
    end

    test "Default implementation of validate returns {:error, reason} if any validate_argument/3 returns {:error, reason}" do
      assert {:error, {Muggle.ExpressionTest.AnotherExpression, [error: @error_msg]}} ==
               AnotherExpression.validate(AnotherExpression.new([1]))
    end

    test "Default implemntation of validate validates all expressions in args" do
      e1 = Expression.new([1, 2, AnotherExpression.new([:atom]), AnotherExpression.new([:atom])])

      e2 =
        Expression.new([
          1,
          2,
          AnotherExpression.new([:atom]),
          AnotherExpression.new(["wont pass validation"])
        ])

      assert {:ok, e1} == Expression.validate(e1)

      assert {:error,
              {
                Muggle.ExpressionTest.Expression,
                [
                  ok: 1,
                  ok: 2,
                  ok: %Muggle.ExpressionTest.AnotherExpression{args: [:atom]},
                  error: {Muggle.ExpressionTest.AnotherExpression, [error: @error_msg]}
                ]
              }} == Expression.validate(e2)
    end
  end

  def error_msg, do: @error_msg
end
