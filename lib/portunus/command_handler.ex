defmodule Protunus.CommandHandler do
  alias Portunus.Locks, as: Locks

  def command_handler([command | args]) do
    cond do
      command == "ready" -> :ok
      command == "ping" -> :pong
      command == "echo" -> hd(args)
      command == "lock" ->
        Locks.add(hd(args))
        :ok
    end
  end
end
