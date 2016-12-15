defmodule ExTV do
  @moduledoc """
  An Elixir API client for theTVDB.com

  All calls to theTVDB.com API require an API key; sign up and get one there.
  To configure ExTV to use the API key, add the following to your application's
  config.exs:

      config :extv, tvdb_api_key: "<your api key>"

  Please see `ExTV.Series` as a starting point for getting about TV series.
  """

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

  def api_key do
    Application.get_env(:extv, :tvdb_api_key) ||
      System.get_env("TVDB_API_KEY")
  end
end
