defmodule ExTV.Login do
  @base_url "https://api.thetvdb.com/"

  def get_token do
    login_request ExTV.Credentials.get(:token)
  end

  defp login_request(nil) do
    @base_url <> "login"
    |> HTTPoison.post(login_request_body, [{"content-type", "application/json"}])
    |> login_response
  end
  defp login_request(token), do: token

  defp login_response({:ok, %HTTPoison.Response{body: body}}) do
    {:ok, body_decode} = Poison.decode(body)
    token = Map.get(body_decode, "token")
    ExTV.Credentials.put(:token, token)
    token
  end

  defp login_request_body do
    {:ok, body} = Poison.encode( %{apikey: Application.get_env(:extv, :tvdb_api_key)} )
    body
  end
end
