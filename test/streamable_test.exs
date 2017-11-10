defmodule ExTV.StreamableTest do
  use ExUnit.Case, async: false

  describe "stream/3" do
    test "streams paginated APIs" do
      mock_data = ["one", "two", "three"]

      # Grab each element from mock_data
      fetch_page = fn page -> {:ok, Enum.slice(mock_data, page - 1, 1)} end

      # Just return the element
      extract = fn resp -> {:ok, resp} end

      # Next page is just page + 1 until the end of the list
      next_page = fn page, _resp ->
        next = cond do
          page == length(mock_data) -> nil
          true -> page + 1
        end
        {:ok, next}
      end

      result = ExTV.Streamable.stream(fetch_page, extract, next_page)
               |> Enum.into([])

      assert result == mock_data
    end

    test "raises an error on soft errors when 'raise' opt is specified as true" do
      mock_data = ["one", "two", "three"]

      # Return an error
      fetch_page = fn _page -> {:error, :no_data} end

      # Just return the element
      extract = fn resp -> {:ok, resp} end

      # Next page is just page + 1 until the end of the list
      next_page = fn page, _resp ->
        next = cond do
          page == length(mock_data) -> nil
          true -> page + 1
        end
        {:ok, next}
      end


      assert_raise RuntimeError, fn ->
        ExTV.Streamable.stream(fetch_page, extract, next_page, [raise: true])
        |> Enum.into([])
      end
    end
  end

  describe "default_extract/1" do
    test "returns the response body's top level 'data' key" do
      response = %{ body: %{ "data" => [1, 2, 3] } }
      result = ExTV.Streamable.default_extract(response)

      assert result == {:ok, [1, 2, 3]}
    end
  end

  describe "default_next_page/2" do
    test "returns ok, nil when current page is equal to next page in response links" do
      current_page = 1
      response = %{ body: %{ "links" => %{ "next" => current_page } } }
      result = ExTV.Streamable.default_next_page(current_page, response)

      assert result == {:ok, nil}
    end

    test "returns ok, page when current page is not equal to next page in response links" do
      current_page = 1
      response = %{ body: %{ "links" => %{ "next" => current_page + 1 } } }
      result = ExTV.Streamable.default_next_page(current_page, response)

      assert result == {:ok, 2}
    end
  end
end