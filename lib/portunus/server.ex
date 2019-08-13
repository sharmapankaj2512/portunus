defmodule Portunus.Server do
  require Logger
  import Portunus.Data, only: [unmarshal: 1, marshal: 1]

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, active: true, reuseaddr: true])
    server_handler(socket)
  end

  defp server_handler(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    receive do
      {:tcp, ^client, data} ->
        unmarshal(data)
        |> command_handler
        |> marshal
        |> write_line(client)
    end

    server_handler(socket)
  end

  defp command_handler(command) do
    cond do
      command == "ready" -> :ok
      command == "ping" -> :pong
    end
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
