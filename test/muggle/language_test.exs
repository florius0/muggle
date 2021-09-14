defmodule Muggle.LanguageTest do
  use ExUnit.Case
  doctest Muggle.Language

  defmodule Some.Expression do
    use Muggle.Expression

    def validate_argument(_, _, _), do: {:error, :expression_cant_be_valid}
  end

  defmodule Interpreter do
    use Muggle.Interpreter

    def run_expression(_, _, _), do: nil
  end

  defmodule Language do
    alias Some.Expression
    use Muggle.Language,
      expressions: [Expression, Some.Expression, custom_name: Expression],
      interpreter: Interpreter
  end

  test "Exports" do
    assert [
             custom_name: 0,
             custom_name: 1,
             expression: 0,
             expression: 1,
             expressions: 0,
             run: 1,
             run: 2,
             some_expression: 0,
             some_expression: 1
           ] == Language.__info__(:functions)
  end

  test "Default implementation defines expressions/0 returns all expressions" do
    assert [
             expression: Some.Expression,
             some_expression: Some.Expression,
             custom_name: Some.Expression
           ] == Language.expressions()
  end
end
