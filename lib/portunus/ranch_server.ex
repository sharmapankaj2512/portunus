defmodule Protunus.Ranch.Server do
  require Logger

  def listen(port) do
    :ranch.start_listener(
      :portunus,
      :ranch_tcp,
      [{:port, port}],
      Protunus.GenProtocol,
      []
    )
  end

  def stop() do
    :ranch.stop_listener(:portunus)
  end
end
