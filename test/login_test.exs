defmodule ExTV.LoginTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import ExTV.Login

  doctest ExTV.Login

  test "get_token/1" do
    use_cassette "login" do
     result = ExTV.Login.get_token
     assert !is_nil(result)
    end
  end
end
