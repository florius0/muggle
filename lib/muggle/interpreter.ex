defmodule Muggle.Interpreter do
  @callback run(Muggle.Expression.t()) :: any()
end
