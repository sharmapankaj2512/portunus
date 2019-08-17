defmodule Protunus.Server do
  use GenServer

  import Protunus.CommandHandler, only: [command_handler: 1]

  @behaviour :ranch_protocol
  @default_protocol Portunus.RedisProtocol

  require Logger

  def start_link(ref, socket, transport, _opts) do
    pid = :proc_lib.spawn_link(__MODULE__, :init, [ref, socket, transport])
    {:ok, pid}
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  @spec init(any, any, atom) :: any
  def init(ref, socket, transport) do
    :ok = :ranch.accept_ack(ref)
    :ok = transport.setopts(socket, [{:active, true}])
    :gen_server.enter_loop(__MODULE__, [], %{socket: socket, transport: transport})
  end

  def handle_info({:tcp, socket, data}, state = %{socket: socket, transport: transport}) do
    reply =
      @default_protocol.unmarshal(data)
      |> command_handler
      |> @default_protocol.marshal

    transport.send(socket, reply)
    {:noreply, state}
  end

  def handle_info({:tcp_closed, socket}, state = %{socket: socket, transport: transport}) do
    transport.close(socket)
    {:stop, :normal, state}
  end
end
