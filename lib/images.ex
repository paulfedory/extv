defmodule ExTV.Images do
  @moduledoc """
  Provides access to theTVDB.com series endpoint for images.
  Fetches image metadata and their URLs for a single TV series.
  For general information relating to a series, please see
  `ExTV.Series`.
  """

  import ExTV.HTTP

  def summary(id) do
    get!("series/#{id}/images").body
  end

  def query_params(id) do
    get!("series/#{id}/images/query/params").body
  end

  def query(id, key_type \\ "fanart") do
    get!("series/#{id}/images/query?keyType=#{key_type}").body
  end

  def posters(id) do
    query(id, "poster")["data"]
    |> Enum.sort(&(&1["ratingsInfo"]["average"] > &2["ratingsInfo"]["average"]))
    |> Enum.map(fn(x) -> update_map_with_full_url(x) end)
  end

  def fanart(id) do
    query(id, "fanart")["data"]
    |> Enum.sort(&(&1["ratingsInfo"]["average"] > &2["ratingsInfo"]["average"]))
    |> Enum.map(fn(x) -> update_map_with_full_url(x) end)
  end

  defp prepend_tvdb_url(path) do
    "https://thetvdb.com/banners/" <> path
  end

  defp update_map_with_full_url(map) do
    Map.put(map, "fileName", prepend_tvdb_url(map["fileName"]))
    |> Map.put("thumbnail", prepend_tvdb_url(map["thumbnail"]))
  end
end
