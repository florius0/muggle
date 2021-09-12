defmodule Muggle.Expression do
  @type args() :: list()

  @type t() :: %{__struct__: module(), args: args()}

  @type ok() :: {:ok, t()}
  @type error() :: {:error, {module(), any()}}
  @type either() :: ok() | error()

  @callback new(any()) :: t()
  @callback validate(t()) :: either()
  @callback validate_argument(any(), integer(), args()) :: {:ok, any()} | error()
  @callback transform(t()) :: either()

  defmacro __using__(_) do
    quote do
      @behaviour Muggle.Expression

      defstruct [:args]

      @impl true
      def new(args) when is_list(args), do: %__MODULE__{args: args}
      def new(args), do: %__MODULE__{args: [args]}

      # TODO: Length validation
      @impl true
      def validate(%__MODULE__{args: args} = x) do
        agg =
          args
          |> Enum.with_index()
          |> Enum.map(fn {arg, idx} -> _validate_argument(arg, idx, args) end)

        if Enum.all?(agg, fn x -> hd(Tuple.to_list(x)) == :ok end) do
          {:ok, x}
        else
          {:error, {__MODULE__, agg}}
        end
      end

      @impl true
      def validate_argument(x, _, _), do: {:ok, x}

      defp _validate_argument(%{__struct__: m} = x, _, _), do: m.validate(x)
      defp _validate_argument(x, i, a), do: validate_argument(x, i, a)

      @impl true
      def transform(expr), do: {:ok, expr}

      defoverridable Muggle.Expression
    end
  end
end
