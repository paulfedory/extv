defmodule ExTV.SeriesTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  doctest ExTV.Series

  setup do
    ExTV.Credentials.reset
  end

  describe "by_id/1" do
    test "success fetch a series by ID" do
      use_cassette "by_id_success" do
       result = ExTV.Series.by_id("77400")

       assert result["data"]["seriesName"] == "The Girl from Tomorrow"
      end
    end

    test "failure to fetch a series by ID" do
      use_cassette "by_id_failure" do
        result = ExTV.Series.by_id("blahblahblah")

        assert result["Error"] == "ID: blahblahblah not found"
      end
    end
  end

  describe "actors/1" do
    test "successfully fetch a series' actors by series ID" do
      use_cassette "actors_success" do
        result = ExTV.Series.actors("77400")

        assert List.first(result)["name"] == "John Howard"
      end
    end

    test "returns nil when it fails to find that series by ID" do
      use_cassette "actors_failure" do
        result = ExTV.Series.actors("blahblahblah")

        assert result == nil
      end
    end
  end

  describe "episodes/1" do
    test "successfully fetch a series' episodes by series ID" do
      use_cassette "episodes_success" do
        result = ExTV.Series.episodes(295685)

        assert List.first(result)["episodeName"] == "Pilot"
      end
    end

    test "returns nil when it fails to find that series by ID" do
      use_cassette "episodes_failure" do
        result = ExTV.Series.episodes(-1)

        assert result == nil
      end
    end
  end

  describe "episodes_summary/1" do
    test "successfully fetch a series' episodes summary by series ID" do
      use_cassette "episodes_summary_success" do
        result = ExTV.Series.episodes_summary(295685)

        assert result["airedEpisodes"] == "44"
      end
    end

    test "returns nil when it fails to find that series by ID" do
      use_cassette "episodes_summary_failure" do
        result = ExTV.Series.episodes_summary(-1)

        assert result == nil
      end
    end
  end
end
