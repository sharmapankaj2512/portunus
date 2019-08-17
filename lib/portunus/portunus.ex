defmodule Protunus.App do
  require Logger

  alias Portunus.Locks, as: Locks

  def listen(port) do
    Locks.init()

    :ranch.start_listener(
      :portunus,
      :ranch_tcp,
      [{:port, port}],
      Protunus.Server,
      []
    )
  end

  def stop() do
    :ranch.stop_listener(:portunus)
  end
end
