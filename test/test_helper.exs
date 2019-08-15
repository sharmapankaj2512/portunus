ExUnit.start()

defmodule TestHelpers do
  require Logger
  alias Portunus.Server, as: Server

  defmacro start_portunus(block) do
    quote do
      spawn(fn -> Server.accept(7878) end)
      TestHelpers.wait_for_server()
      unquote(block)
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

  def send_message(command) do
    opts = [:binary, active: false]
    {_, client} = :gen_tcp.connect('localhost', 7878, opts)
    :gen_tcp.send(client, format_array([command]))
     case :gen_tcp.recv(client, 0, 5000) do
      {:ok, data} -> data
      {:error, _} -> :failed
     end
  end

  def send_message(command, message) do
    opts = [:binary, active: false]
    {_, client} = :gen_tcp.connect('localhost', 7878, opts)
    :gen_tcp.send(client, format_array([command, message]))
    case :gen_tcp.recv(client, 0, 5000) do
      {:ok, data} -> data
      {:error, _} -> :failed
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
