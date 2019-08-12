defmodule Portunus.Server do
  require Logger
  import Portunus.Data, only: [unmarshal: 1]

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, active: true, reuseaddr: true])
    server_handler(socket)
  end

  defp server_handler(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    receive do
      {:tcp, ^client, data} ->
        command = unmarshal(data)

        cond do
          command == "ready" ->
            write_line("+OK/r/n", client)

          command == "ping" ->
            write_line("+PONG/r/n", client)
        end
    end

    server_handler(socket)
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
