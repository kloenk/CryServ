defmodule CryServTest do
  use ExUnit.Case
  doctest CryServ

  test "greets the world" do
    assert CryServ.hello() == :world
  end
end
