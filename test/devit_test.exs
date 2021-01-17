defmodule DevitTest do
  use ExUnit.Case
  doctest Devit

  test "greets the world" do
    assert Devit.hello() == :world
  end
end
