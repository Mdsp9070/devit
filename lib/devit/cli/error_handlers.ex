defmodule Devit.Cli.ErrorHandlers do
  @moduledoc """
  Handle common CLI errors
  """

  import Devit.Colors, only: [error: 1, warning: 2]

  @spec unkown_opts([atom()]) :: :ok
  def unkown_opts(invalid) do
    desc = "I really don't know what to do with these options:\n#{inspect(invalid)}"

    "What are these?"
    |> warning(desc)
  end

  def no_opts do
    "Well, You didn't say me nothing so, what I need to do?" |> error()
  end

  @spec extract_options([{atom(), String.t() | boolean()}]) :: [atom()]
  def extract_options(parsed) do
    parsed
    |> Enum.map(fn {op, _} -> op end)
  end
end
