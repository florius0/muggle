# Muggle

![WotStat CI](https://github.com/WOT-STAT/wotstat/actions/workflows/elixir.yml/badge.svg)
[![codecov](https://codecov.io/gh/florius0/muggle/branch/main/graph/badge.svg?token=L5K6PU9R0F)](https://codecov.io/gh/florius0/muggle)

Muggle is a collection of behaviours to help with buillding DSLs in Elixir

## Example

Define expressions

```elixir
defmodule DSL.Expression do
  use Muggle.Expression
end
```

Define interpreter of your expressions

```elixir
defmodule DSL.Interpreter
  @behaviour Muggle.Interpreter

  @impl true
  def run(expression, opts \\ []), do: {:ok, :hello_world}
end
```

Define your language

```elixir
defmodule DSL.Language
  alias DSL.Expression

  use Muggle.Language, 
    expressions: [
      Expression, 
      DSL.Expression, 
      custom_name: Exprression
    ],
    interpreter: DSL.Interpreter
end
```

Use it

```elixir
import DSL.Language

expression() |> run()

# override interpreter
expression() |> run(interpreter: DSL.AnotherInterpreter)
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
