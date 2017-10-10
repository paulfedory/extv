defmodule ExTVTest do
  use ExUnit.Case
  doctest ExTV

  describe "api_key/0" do
    test "fetches the user's TVDB API key from app config when present" do
      assert !is_nil(ExTV.api_key)
    end
  end
end
