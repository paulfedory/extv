defmodule ExTV.Credentials do
  @doc """
  Creates the bucket to hold a TVDB user's credentials as key value pairs
  """
  def start_link do
    Agent.start_link(fn -> %{} end, name: :credentials)
  end

  @doc """
  Gets the value corresponding with `key`
  """
  def get(key) do
    Agent.get(:credentials, &Map.get(&1, key))
  end

  @doc """
  Puts a new value / replaces an existing value at `key` with `value`
  """
  def put(key,value) do
    Agent.update(:credentials, &Map.put(&1,key,value))
  end

  @doc """
  Resets the state of the agent, starting with a new Map
  """
  def reset do
    Agent.cast(:credentials, fn(_) -> %{} end)
  end
end
