defmodule Isn.ISSN13Test do
  use ExUnit.Case, async: true

  @test_issn "977-1436-452-00-8"

  test "cast" do
    assert Isn.ISSN13.cast(@test_issn) == {:ok, @test_issn}
    assert Isn.ISSN13.cast(nil) == :error
  end

  test "load" do
    assert Isn.ISSN13.load(@test_issn) == {:ok, @test_issn}
  end

  test "dump" do
    assert Isn.ISSN13.dump(@test_issn) == {:ok, @test_issn}
  end
end
