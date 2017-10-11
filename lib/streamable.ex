defmodule ExTV.Streamable do
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

  @spec default_extract(map()) :: {:ok, map()}
  def default_extract(response) do
    {:ok, response.body["data"]}
  end

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