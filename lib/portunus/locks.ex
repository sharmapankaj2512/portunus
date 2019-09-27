defmodule Portunus.Locks do
  use Agent

  alias Portunus.Error, as: Error
  @time Application.get_env(:portunus, :time)

  def start_link(_opts) do
    init()
  end

  def init(initial_value \\ {%{}, %{}}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def add(key) do
    Agent.update(__MODULE__, &add_lock(&1, key))
  end

  def exists(key) do
    expired = Agent.get(__MODULE__, &has_expired(&1, key))
    if expired, do: release(key)
    Agent.get(__MODULE__, &has_lock(&1, key))
  end

  def release(key) do
    Agent.update(__MODULE__, &delete_lock(&1, key))
  end

  def expires(key, seconds) do
    Agent.update(__MODULE__, &add_expiry(&1, key, seconds))
  end

  defp add_lock({locks, expiries}, key) do
    {Map.put(locks, key, true), expiries}
  end

  defp has_lock({locks, _}, key) do
    if(Map.has_key?(locks, key), do: :ok, else: %Error{})
  end

  defp delete_lock({locks, expires}, key) do
    {Map.delete(locks, key), Map.delete(expires, key)}
  end

  defp add_expiry({locks, expires}, key, seconds) do
    {locks, Map.put(expires, key, @time.now() + seconds)}
  end

  defp has_expired({locks, expires}, key) do
    expiry = Map.get(expires, key, false)
    if expiry < @time, do: true, else: false
  end
end
