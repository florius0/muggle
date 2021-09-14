defmodule Muggle.Interpreter do
  @callback run(Muggle.Expression.t(), keyword()) :: {:ok, any()} | {:error, any()}
  @callback run_expression(Muggle.Expression.t(), Muggle.Expression.t(), keyword()) ::
              {:ok, any()} | {:error, any()}

  defmacro __using__(_) do
    quote do
      @behaviour Muggle.Interpreter

      @impl true
      def run(%{} = expression, opts) do
        _run_expression(expression, expression, opts)
      end

      defp _run_expression(%{__struct__: m, args: args} = expression, env, opts) do
        agg =
          args
          |> Enum.map(fn
            %{__struct__: _m, args: _args} = e -> _run_expression(e, env, opts)
            x -> {:ok, x}
          end)

        if Enum.all?(agg, fn x -> hd(Tuple.to_list(x)) == :ok end) do
          struct!(m, args: Enum.map(agg, fn {:ok, x} -> x end))
          |> run_expression(env, opts)
        else
          {:error, {m, agg}}
        end
      end
    end
  end
end
