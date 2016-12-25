defmodule ExTV.ImagesTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  doctest ExTV.Images

  setup do
    ExTV.Credentials.reset
  end

  test "summary/1 success" do
    use_cassette "summary_success" do
     result = ExTV.Images.summary("296762")

     assert result["data"]["fanart"] == 6
    end
  end

  test "summary/1 failure" do
    use_cassette "summary_failure" do
      result = ExTV.Images.summary("blahblahblah")

      assert result["Error"] == "Resource not found"
    end
  end

  test "query_params/1 success" do
    use_cassette "query_params_success" do
     result = ExTV.Images.query_params("296762")

     assert List.first(result["data"])["keyType"] == "fanart"
    end
  end

  test "query_params/1 failure" do
    use_cassette "query_params_failure" do
      result = ExTV.Images.query_params("blahblahblah")

      assert result["Error"] == "Resource not found"
    end
  end

   test "query/1 success" do
    use_cassette "query_success" do
     result = ExTV.Images.query("296762", "poster")

     assert List.first(result["data"])["keyType"] == "poster"
    end
  end

  test "query/1 failure" do
    use_cassette "query_failure" do
      result = ExTV.Images.query("blahblahblah")

      assert result["Error"] == "No results for your query: map[keyType:fanart keyValue:blahblahblah]"
    end
  end

  test "posters/1 successfully queries for posters, sorts & cleans the result" do
    use_cassette "posters_success" do
     result = ExTV.Images.posters("296762")

     assert List.first(result)["keyType"] == "poster"
     assert List.first(result)["fileName"] == "https://thetvdb.com/banners/posters/296762-3.jpg"
    end
  end

  test "fanart/1 successfully queries for posters, sorts & cleans the result" do
    use_cassette "fanart_success" do
     result = ExTV.Images.fanart("296762")

     assert List.first(result)["keyType"] == "fanart"
     assert List.first(result)["fileName"] == "https://thetvdb.com/banners/fanart/original/296762-7.jpg"
    end
  end
end
