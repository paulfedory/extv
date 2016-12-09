defmodule ExTV.LoginTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  doctest ExTV.Login

  setup do
    ExTV.Credentials.reset
  end

  test "get_token/1" do
    use_cassette "login" do
     result = ExTV.Login.get_token
     assert !is_nil(result)
     assert is_binary(result)
    end
  end
end
