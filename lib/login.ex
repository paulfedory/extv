defmodule ExTV.Login do
  @moduledoc false

  import ExTV.HTTP, only: [process_request_options: 1, process_url: 1]

  def get_token do
    login_request ExTV.Credentials.get(:token)
  end

  defp login_request(nil) do
    process_url("login")
    |> HTTPoison.post(login_request_body(), [{"content-type", "application/json"}], process_request_options([]))
    |> login_response()
  end
  defp login_request(token), do: token

  defp login_response({:ok, %HTTPoison.Response{body: body}}) do
    {:ok, body_decode} = Poison.decode(body)
    token = Map.get(body_decode, "token")
    ExTV.Credentials.put(:token, token)
    token
  end

  defp login_request_body do
    {:ok, body} = Poison.encode( %{apikey: ExTV.api_key} )
    body
  end
end
