defmodule ExTV.SeriesTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  doctest ExTV.Series

  test "by_id/1 success" do
    use_cassette "by_id_success" do
     result = ExTV.Series.by_id("77400")

     assert result.body["data"]["seriesName"] == "The Girl from Tomorrow"
    end
  end

  test "by_id/1 failure" do
    use_cassette "by_id_failure" do
      result = ExTV.Series.by_id("blahblahblah")

      assert result.body["Error"] == "ID: blahblahblah not found"
    end
  end
end