ExUnit.start()

defmodule TestHelpers do
  require Logger
  alias Portunus.Server, as: Server

  defmacro start_portunus(block) do
    quote do
      spawn(fn -> Server.accept(7878) end)
      send_message("READY")
      unquote(block)
    end
  end

  def send_message(command) do
    opts = [:binary, active: true]
    {_, client} = :gen_tcp.connect('localhost', 7878, opts)
    :gen_tcp.send(client, format_array([command]))

    receive do
      {:tcp, ^client, data} ->
        data
    end
  end

  def send_message(command, message) do
    opts = [:binary, active: true]
    {_, client} = :gen_tcp.connect('localhost', 7878, opts)
    :gen_tcp.send(client, format_array([command, message]))

    receive do
      {:tcp, ^client, data} ->
        data
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
