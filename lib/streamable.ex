defmodule ExTV.Streamable do
  @doc """
  Sets up a stream for a paginated API call based on 3 functions;

  - A function which given a page number, will call the API for the page
  - A function which will extract the desired data from the response
  - A function which will calculate the number of the next page from the current page and response

  This module provides defaults for the last two functions: default_extract/1 and default_next_page/2
  Errors raised when fetching a page will result in an empty enumeration.

  Example:

      iex> ExTV.Streamable.stream(
      ...> fn page -> ExTV.HTTP.get("https://someapi.com/?page=#\{page\}") end,
      ...> &ExTV.Streamable.default_extract/1,
      ...> &ExTV.Streamable.default_next_page/2
      ...> )
      #Function<50.40091930/2 in Stream.resource/3>
  """
  @spec stream((integer -> map()), (map() -> map()), (integer, map() -> integer)) :: Enumerable.t
  def stream(fetch_page, extract_data \\ &default_extract/1, calc_next_page \\ &default_next_page/2) do
    start_fn = fn ->
      start(fetch_page, extract_data, calc_next_page)
    end

    next_fn = fn state ->
      next_item(fetch_page, extract_data, calc_next_page, state)
    end

    stop_fn = fn _state ->
      stop()
    end

    Stream.resource(start_fn, next_fn, stop_fn)
  end

  @doc """
  A default extraction function which will return the top level 'data' key in the response body

  Example:
      iex> ExTV.Streamable.default_extract(%{ body: %{ "data" => "Cookies" } })
      {:ok, "Cookies"}
  """
  @spec default_extract(map()) :: {:ok, map()}
  def default_extract(response) do
    {:ok, response.body["data"]}
  end

  @doc """
  A default function which will calculate the next page number to fetch based on the current
  number and API response using the top level 'links' key which provides pagination info.
  Returns nil when the final page is reached.

  Example:
      iex(4)> ExTV.Streamable.default_next_page(1, %{ body: %{ "links" => %{ "next" => 1 } } })
      {:ok, nil}

      iex(5)> ExTV.Streamable.default_next_page(1, %{ body: %{ "links" => %{ "next" => 2 } } })
      {:ok, 2}
  """
  @spec default_next_page(number, map()) :: {:ok, number} | {:ok, nil}
  def default_next_page(current_page, response) do
    next = case response.body["links"]["next"] do
             ^current_page -> nil
             page -> page
           end

    {:ok, next}
  end

  defp start(fetch_page, extract_data, calc_next_page) do
    with {:ok, response} <- fetch_page.(1),
         {:ok, data} <- extract_data.(response),
         {:ok, next_page_number} <- calc_next_page.(1, response) do
      { data, next_page_number }
    else
      error -> { :halt, error}
    end
  end

  defp next_item(_fetch, _extract, _next, {[], nil} = state) do
    {:halt, state}
  end

  defp next_item(fetch_page, extract_data, calc_next_page, {[], next_page_number} = state) do
    with {:ok, response} <- fetch_page.(next_page_number),
         {:ok, [head | tail]} <- extract_data.(response),
         {:ok, new_next_page_number} <- calc_next_page.(next_page_number, response) do
      {[head], { tail, new_next_page_number }}
    else
      _ -> { :halt, state }
    end
  end

  defp next_item(_fetch, _extract, _next, {[head | tail], next_page_number}) do
    {[head], {tail, next_page_number}}
  end

  defp next_item(_fetch, _extract, _next, {:halt, _} = error), do: error

  defp stop() do
    :ok
  end
end