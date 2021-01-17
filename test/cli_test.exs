defmodule Devit.CLITest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  alias Devit.CLI

  @article_path "~/Documents/article.md"

  describe "main/1" do
    # For now the cli don't call the core module
    test "main with correct args should return nothing" do
      assert {:ok, path} = CLI.main(["--article-path", @article_path])
      assert path == @article_path
    end

    test "main called with unkown args prints a warning" do
      assert capture_io(fn -> CLI.unkown_opts(p: nil) end) =~ "What are these?"
    end

    test "main called with no arguments prints error" do
      assert capture_io(fn -> CLI.default_error() end) =~ "No article/markdown"
    end
  end
end
