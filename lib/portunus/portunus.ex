defmodule Portunus.App do
  require Logger

  def listen(port \\ 7878) do
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

  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :listen, []},
      type: :supervisor,
      restart: :permanent,
    }
  end
end
