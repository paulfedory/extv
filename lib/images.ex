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
    |> Enum.map(fn(x) ->
      Map.put(x, "fileName", "http://thetvdb.com/banners/" <> x["fileName"])
      |> Map.put("thumbnail", "http://thetvdb.com/banners/" <> x["thumbnail"])
    end)
  end
end
