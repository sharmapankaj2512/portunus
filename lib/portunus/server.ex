defmodule Portunus.Server do
  require Logger
  @default_protocol Portunus.RedisProtocol

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])
    server_handler(socket, @default_protocol)
  end

  defp server_handler(socket, protocol) do
    {:ok, client} = :gen_tcp.accept(socket)
    case :gen_tcp.recv(client, 0, 5000) do
      {:ok, data} ->
        protocol.unmarshal(data)
        |> command_handler
        |> protocol.marshal
        |> write_line(client)
      {:error, _} ->
        write_line( "-ERR server side error", client)
    end

    server_handler(socket, protocol)
  end

  defp command_handler([command | args]) do
    cond do
      command == "ready" -> :ok
      command == "ping" -> :pong
      command == "echo" -> hd(args)
    end
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
