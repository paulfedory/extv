defmodule ExTV.Series do
  @moduledoc """
  Provides access to theTVDB.com series endpoint. Fetches information about
  a single TV series. For images relating to the series, please see
  `ExTV.Images`.
  """

  import ExTV.HTTP
  import ExTV.Streamable

  @doc """
  Fetches information about a single TV series.

  Returns a map containing the data, or an error message if the series
  cannot be found. Raises an error if the underlying request fails.

  ## Parameters

    - id: the ID of the series on theTVDB.com
  """
  def by_id(id) do
    get!("series/#{id}").body
  end

  @doc """
  Fetches information about actors for a single TV series.

  Returns a map containing the data, or nil if the series
  cannot be found. Raises an error if the underlying request fails.

  ## Parameters

    - id: the ID of the series on theTVDB.com
  """
  @spec actors(number) :: map() | nil
  def actors(id) do
    get!("series/#{id}/actors").body["data"]
  end

  @doc """
  Fetches an enumerable of episodes for the given series id

  ## Parameters

    - id: the ID of the series on theTVDB.com
  """
  @spec episodes(number) :: Enumerable.t
  def episodes(id) do
    fetch_page = fn page ->
      get!("series/#{id}/episodes?page=#{page}")
      |> handle_response()
    end

    stream(fetch_page)
  end

  @doc """
  Fetches a summary of the episodes and seasons available for the given series


  ## Parameters

    - id: the ID of the series on theTVDB.com
  """
  @spec episodes_summary(number) :: map() | nil
  def episodes_summary(id) do
    get!("series/#{id}/episodes/summary").body["data"]
  end
end
