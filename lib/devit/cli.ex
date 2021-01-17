defmodule Devit.CLI do
  @moduledoc """
  Escript main module where cli options are parsed
  """

  import Devit.Colors

  alias Devit.Core

  def main(args \\ []) do
    args
    |> parse_args()
    |> case do
      path when is_binary(path) ->
        {:ok, path}

      err when is_tuple(err) ->
        err

      _ ->
        {:error, :unkown_error}
    end
    |> Core.post()
  end

  defp parse_args(args) do
    opts = [strict: [article_path: :string], aliases: [a: :article_path]]

    case OptionParser.parse(args, opts) do
      {[{_op, path}], _, invalid} ->
        unless Enum.empty?(invalid), do: unkown_opts(invalid)
        path

      {[], _, invalid} ->
        unkown_opts(invalid)
        default_error()
    end
  end

  def unkown_opts(invalid) do
    invalid =
      invalid
      |> Enum.map(fn {op, _} -> op end)

    desc = "I really don't know what to do with these options:\n#{inspect(invalid)}"

    "What are these?"
    |> warning(desc)
  end

  def default_error do
    desc = "Please, provide a article/markdown file with --article-path/-a option!"

    "No article/markdown"
    |> error(desc)

    {:error, :default_error}
  end
end
