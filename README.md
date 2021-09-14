# Muggle

![WotStat CI](https://github.com/WOT-STAT/wotstat/actions/workflows/elixir.yml/badge.svg)
[![codecov](https://codecov.io/gh/florius0/muggle/branch/main/graph/badge.svg?token=L5K6PU9R0F)](https://codecov.io/gh/florius0/muggle)

Muggle is a collection of behaviours to help with buillding DSLs in Elixir

## Example

Define expressions

```elixir
defmodule Calculator.Add do
  use Muggle.Expression

  def validate_argument(x, _idx, _all_arguments) when is_number(x), do: {:ok, x}
  def validate_argument(_, _, _), do: {:error, :not_a_number}

  def validate(%__MODULE__{args: args} = x) when length(args) == 2, do: super(x)
  def validate(_), do: {:error, {__MODULE__, :invalid_number_of_arguments}}
end
```

Define interpreter of your expressions

```elixir
defmodule Calculator.Interpreter do
  @behaviour Muggle.Interpreter

  @impl true
  def run_expression(%Calculator.Add{args: [a, b]}, _, _), do: {:ok, a + b}
  def run_expression(_, _, _), do: {:error, :unsupported_expression}
end
```

Define your language

```elixir
defmodule Calculator do
  use Muggle.Language, 
    expressions: [add: Calculator.Add],
    interpreter: Calculator.Interpreter
end
```

Use it

```elixir
iex(1)> import Calculator

iex(2)> add([1,2]) |> run()
{:ok, 3}

iex(3)> add([1, 2, 3]) |> run()
{:error, {Calculator.Add, :invalid_number_of_arguments}}

iex(4)> add([1, "string"]) |> run()
{:error, {Calculator.Add, [ok: 1, error: :not_a_number]}}
```

## Roadmap

- Add "lazy" expression build as implementation of `Muggle.Language` behaviour to enable dynamic expreession building
- Improve `Muggle.Interpreter`
- Add docs

## Installation

Add `muggle` to your list of dependencies in `mix.exs`

```elixir
def deps do
  [
    {:muggle, git: "https://github.com/florius0/muggle"}
  ]
end
```

<!-- If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `muggle` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:muggle, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/muggle](https://hexdocs.pm/muggle). -->
