defmodule Protunus.CommandHandler do
  alias Portunus.Locks, as: Locks

  def command_handler([command | args]) do
    cond do
      command == "ready" ->
        :ok

      command == "ping" ->
        :pong

      command == "echo" ->
        hd(args)

      command == "lock" ->
        Locks.add(hd(args))

      command == "exists" ->
        Locks.exists(hd(args))

      command == "release" ->
        Locks.release(hd(args))

      command == "expires" ->
        [key, seconds] = args
        Locks.expires(key, String.to_integer(seconds))
    end
  end
end
