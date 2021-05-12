defmodule Devit.CLI do
  @moduledoc """
  Escript main module where cli options are parsed
  """

  alias Devit.Cli.{ErrorHandlers, Help}
  alias Devit.Core

  def main(args \\ []) do
    args
    |> parse_args()
    |> case do
      {:ok, parsed} -> parsed |> handle_commands()
      :error -> System.halt(1)
    end
  end

  defp parse_args(args) do
    opts = [
      strict: [article_path: :string, help: :boolean],
      aliases: [a: :article_path, h: :help]
    ]

    case OptionParser.parse(args, opts) do
      {[], _, []} ->
        ErrorHandlers.no_opts()

        :error

      {_, _, invalid} when invalid != [] ->
        invalid
        |> ErrorHandlers.extract_options()
        |> ErrorHandlers.unknown_opts()

        :error

      {parsed, _, invalid} ->
        unless Enum.empty?(invalid) do
          invalid
          |> ErrorHandlers.extract_options()
          |> ErrorHandlers.unknown_opts()
        end

        {:ok, parsed}
    end
  end

  defp handle_commands(help: true), do: Help.build()
  defp handle_commands(article_path: path) when is_binary(path), do: path |> Core.run()
end
