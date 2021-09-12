defmodule Muggle.Language do
  defmacro __using__(expressions: e) do
    expressions = Enum.map(e, fn
      {name, module} ->
        {name, module}

      module ->
        {module
         |> Macro.expand(__ENV__)
         |> Module.split()
         |> tl()
         |> Enum.map(&String.downcase/1)
         |> Enum.join("_")
         |> String.to_atom(), module}
    end)

    quote do
      def expressions, do: unquote(expressions)

      unquote(
        for {name, mod} <- expressions do
          quote do
            def unquote(name)(args \\ []), do: unquote(mod).new(args)
          end
        end
      )
    end
  end
end
