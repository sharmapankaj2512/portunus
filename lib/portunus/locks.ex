defmodule Portunus.Locks do
  use Agent

  def init(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def add(key) do
    Agent.update(__MODULE__, &(Map.put(&1, key, true) ))
  end
end
