defmodule Devit.CLITest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  alias Devit.CLI

  describe "main/1" do
    test "main called with unkown args prints a warning" do
      assert capture_io(fn -> CLI.unkown_opts(p: nil) end) =~ "What are these?"
    end

    test "main called with no arguments prints error" do
      assert capture_io(fn -> CLI.default_error() end) =~ "No article/markdown"
    end
  end
end
