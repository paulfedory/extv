defmodule ExTVTest do
  use ExUnit.Case
  doctest ExTV

  test "fetches the user's TVDB API key" do
    assert !is_nil(ExTV.api_key)
  end
end
