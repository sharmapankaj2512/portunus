defmodule Protunus.CommandHandler do
  def command_handler([command | args]) do
    cond do
      command == "ready" -> :ok
      command == "ping" -> :pong
      command == "echo" -> hd(args)
    end
  end
end
