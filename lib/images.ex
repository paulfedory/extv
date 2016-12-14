defmodule ExTV.Images do
  import ExTV

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

  def prepend_tvdb_url(path) do
    "http://thetvdb.com/banners/" <> path
  end

  def update_map_with_full_url(map) do
    Map.put(map, "fileName", prepend_tvdb_url(map["fileName"]))
    |> Map.put("thumbnail", prepend_tvdb_url(map["thumbnail"]))
  end
end
