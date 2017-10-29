defmodule ExTV.HTTP do
  use HTTPoison.Base

  @moduledoc false

  @base_url "https://api.thetvdb.com/"

  @default_timeout 8000
  @default_recv_timeout 5000

  def process_url(path) do
    @base_url <> path
  end

  def process_response_body(body) do
    Poison.decode!(body)
  end

  def process_request_headers(headers) do
    headers ++
      [
        {"content-type", "application/json"},
        {"accept", "application/json"},
        {"Authorization", "Bearer #{ExTV.Login.get_token}"}
      ]
  end

  def process_request_options(options) do
    options ++
      [
        {:timeout, timeout()},
        {:recv_timeout, recv_timeout()}
      ]
  end

  def handle_response(response) do
    case response do
      nil                        -> {:error, :no_data}
      %{status_code: 200} = resp -> {:ok, resp}
      _                          -> {:error, :bad_response, response}
    end
  end

  defp timeout do
    Application.get_env(:extv, :http_timeout, @default_timeout)
  end

  defp recv_timeout do
    Application.get_env(:extv, :http_recv_timeout, @default_recv_timeout)
  end

end
