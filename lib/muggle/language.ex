defmodule Muggle.Language do
  @callback expressions() :: keyword(module())
  @callback run(Muggle.Expression.t(), keyword()) ::
              {:ok, any()} | {:error, any()} | Muggle.Expression.error()

  defmacro __using__(expressions: e, interpreter: i) do
    expressions =
      Enum.map(e, fn
        {name, module} ->
          {name, module}

        module ->
          {module
           |> Macro.expand(__ENV__)
           |> Module.split()
           |> Enum.map(&String.downcase/1)
           |> Enum.join("_")
           |> String.to_atom(), module}
      end)

    quote do
      @behaviour Muggle.Language

      @impl true
      def expressions, do: unquote(expressions)

      unquote(
        for {name, mod} <- expressions do
          quote do
            def unquote(name)(args \\ []), do: unquote(mod).new(args)
          end
        end
      )

      @impl true
      def run(expression, opts \\ []) do
        interpreter = Keyword.get(opts, :interpreter, unquote(i))

        interpreter.run(expression, opts)
      end
    end
  end
end
