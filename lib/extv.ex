defmodule ExTV do
  use Application
  use HTTPoison.Base
  require Logger

  @base_url "https://api.thetvdb.com/"

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(ExTV.Credentials, []),
    ]

    opts = [strategy: :one_for_one, name: ExTV.Supervisor]
    Supervisor.start_link(children, opts)
  end

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
end
