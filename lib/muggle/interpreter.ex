defmodule Muggle.Interpreter do
  @callback run(Muggle.Expression.t(), keyword()) :: {:ok, any()} | {:error, any()}
end
