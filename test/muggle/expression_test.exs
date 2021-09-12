defmodule Muggle.ExpressionTest do
  use ExUnit.Case
  doctest Muggle.Expression

  describe "t" do
    defmodule From do
      use Muggle.Expression


      def validate_argument(x, _, _) when is_atom(x) or is_bitstring(x), do: {:ok, x}
      def validate_argument(_, _, _), do: {:error, "unsupported type"}
    end

    defmodule Select do
      use Muggle.Expression
    end

    test "tt" do
      Select.new([1, 2, 3, From.new(1)])
      |> Select.validate()
      |> IO.inspect()
    end
  end
end
