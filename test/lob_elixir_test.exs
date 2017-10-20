defmodule LobTest do
  use ExUnit.Case
  doctest Lob

  test "greets the world" do
    assert Lob.hello("world") === "Hello world"
  end
end
