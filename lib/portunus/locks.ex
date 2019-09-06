defmodule Portunus.Locks do
  use Agent

  alias Portunus.Error, as: Error

  def start_link(_opts) do
    init()
  end

  def init(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def add(key) do
    Agent.update(__MODULE__, &Map.put(&1, key, true))
  end

  def exists(key) do
    Agent.get(__MODULE__, &if(Map.has_key?(&1, key), do: :ok, else: %Error{}))
  end

  def release(key) do
    Agent.update(__MODULE__, &Map.delete(&1, key))
  end
end
