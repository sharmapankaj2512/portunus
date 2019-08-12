ExUnit.start()

defmodule TestHelpers do
  require Logger
  alias Portunus.Server, as: Server

  defmacro start_portunus(block) do
    quote do
      spawn(fn ->
        Server.accept(7878)
      end)

      send_message("READY")
      unquote(block)
    end
  end

  def send_message(message) do
    opts = [:binary, active: true]
    {_, client} = :gen_tcp.connect('localhost', 7878, opts)
    :gen_tcp.send(client, format_message(message))

    receive do
      {:tcp, ^client, data} ->
        data
    end
  end

  defp format_message(message) do
    "*1\r\n#{String.length(message)}\r\n#{message}\r\n"
  end
end
