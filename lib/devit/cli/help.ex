defmodule Devit.Cli.Help do
  @moduledoc """
  Cli help builder module
  """

  import Devit.Colors, only: [green: 1, yellow: 1]

  def build do
    vsn = get_version()

    "#{green("devit")} v#{vsn}\n"
    |> IO.puts()

    yellow("USAGE:") |> IO.puts()

    IO.puts("    devit [options]\n")

    yellow("OPTIONS") |> IO.puts()
    green("    -h, --help") |> IO.puts()
    IO.puts("            Shows this help section")

    green("    -a, --article-path") |> IO.puts()
    IO.puts("            Provide a markdown article to be published to dev.to")
  end

  defp get_version do
    {:ok, vsn} = :application.get_key(:devit, :vsn)

    vsn
  end
end
