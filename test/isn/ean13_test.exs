defmodule ISN.EAN13Test do
  use ExUnit.Case, async: true

  @test_ean "022-035648348-1"

  test "cast" do
    assert ISN.EAN13.cast(@test_ean) == {:ok, @test_ean}
    assert ISN.EAN13.cast(nil) == :error
  end

  test "load" do
    assert ISN.EAN13.load(@test_ean) == {:ok, @test_ean}
  end

  test "dump" do
    assert ISN.EAN13.dump(@test_ean) == {:ok, @test_ean}
  end
end

