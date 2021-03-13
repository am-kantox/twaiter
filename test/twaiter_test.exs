defmodule TwaiterTest do
  use ExUnit.Case
  doctest Twaiter

  test "greets the world" do
    assert Twaiter.hello() == :world
  end
end
