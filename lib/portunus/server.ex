defmodule Portunus.Server do
  require Logger
  import String, only: [downcase: 1]

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

  defp unmarshal(data) do
    # handle failure scenarions
    # what if * is not present
    # what if number of args is not present
    {:ok, result} =
      StringIO.open(data, [capture_prompt: false], fn pid ->
        if IO.getn(pid, "", 1) == "*" do
          num_args = String.to_integer(IO.getn(pid, "", 1))

          for _i <- 1..num_args do
            # /r/n
            IO.getn(pid, "", 2)
            len = String.to_integer(IO.getn(pid, "", 1))
            # /r/n
            IO.getn(pid, "", 2)
            IO.getn(pid, "", len)
          end
        end
      end)

    downcase(hd(result))
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
