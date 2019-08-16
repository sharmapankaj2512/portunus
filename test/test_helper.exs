ExUnit.start()

defmodule TestHelpers do
  require Logger
  alias Protunus.Ranch.Server, as: Server

  defmacro start_portunus(block) do
    quote do
      Server.listen(7878)
      TestHelpers.wait_for_server()
      unquote(block)
      Server.stop()
    end
  end

  def wait_for_server() do
    opts = [:binary, active: false]

    case :gen_tcp.connect('localhost', 7878, opts) do
      {:ok, client} ->
        :gen_tcp.shutdown(client, :read_write)

      {:error, _} ->
        wait_for_server()
    end
  end

  def send_message(messages) do
    opts = [:binary, active: false, reuseaddr: false]

    case :gen_tcp.connect('localhost', 7878, opts) do
      {:ok, client} ->
        :gen_tcp.send(client, format_array(messages))

        case :gen_tcp.recv(client, 0) do
          {:ok, data} ->
            :gen_tcp.shutdown(client, :read_write)
            data

          {:error, reason} ->
            reason
        end
      {:error, :econnreset} ->
        :econnreset
    end
  end

  def format_array(messages) do
    "*#{length(messages)}\r\n" <> format_strings(messages)
  end

  defp format_strings(messages) do
    Enum.join(Enum.map(messages, &format_string/1))
  end

  defp format_string(message) do
    "$#{String.length(message)}\r\n#{message}\r\n"
  end
end
