defmodule ExTV.Series do
  import ExTV

  def by_id(id) do
    get!("series/#{id}")
  end
end
