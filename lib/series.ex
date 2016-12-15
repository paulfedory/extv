defmodule ExTV.Series do
  @moduledoc """
  Provides access to theTVDB.com series endpoint. Fetches information about
  a single TV series. For images relating to the series, please see
  `ExTV.Images`.
  """

  import ExTV

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
end
