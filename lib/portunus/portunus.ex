defmodule Protunus.App do
  require Logger

  def listen(port) do
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
