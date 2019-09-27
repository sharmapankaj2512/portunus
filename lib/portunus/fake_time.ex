defmodule Portunus.FakeTime do
  use Agent

  @behaviour Portunus.Time

  def start_link(_opts) do
    init()
  end

  def init(initial_value \\ 0) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def now() do
    Agent.get(__MODULE__, & &1)
  end

  def sleep(seconds) do
    Agent.update(__MODULE__, &(&1 + seconds))
  end
end
