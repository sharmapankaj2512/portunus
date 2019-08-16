defmodule Protunus.GenProtocol do
  use GenServer

  @behaviour :ranch_protocol
  @default_protocol Portunus.RedisProtocol

  require Logger

  def start_link(ref, socket, transport, _opts) do
    pid = :proc_lib.spawn_link(__MODULE__, :init, [ref, socket, transport])
    {:ok, pid}
  end

  def init(ref, socket, transport) do
    :ok = :ranch.accept_ack(ref)
    :ok = transport.setopts(socket, [{:active, true}])
    :gen_server.enter_loop(__MODULE__, [], %{socket: socket, transport: transport})
  end

  def handle_info({:tcp, socket, data}, state = %{socket: socket, transport: transport}) do
    reply = @default_protocol.unmarshal(data)
    |> command_handler
    |> @default_protocol.marshal
    transport.send(socket, reply)
    {:noreply, state}
  end

  def handle_info({:tcp_closed, socket}, state = %{socket: socket, transport: transport}) do
    transport.close(socket)
    {:stop, :normal, state}
  end

  defp command_handler([command | args]) do
    cond do
      command == "ready" -> :ok
      command == "ping" -> :pong
      command == "echo" -> hd(args)
    end
  end
end
