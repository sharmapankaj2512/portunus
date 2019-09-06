defmodule ServerTest do
  use ExUnit.Case
  require Logger

  import TestHelpers,
    only: [
      send_message: 1,
      start_portunus: 1
    ]

  describe "Portunus.Server" do
    test "responds to ping" do
      start_portunus do
        assert send_message(["PING"]) == "+PONG\r\n"
      end
    end

    test "supports multiple clients" do
      start_portunus do
        times = 15

        result =
          List.duplicate("PING", times)
          |> Enum.map(&Task.async(fn -> send_message([&1]) end))
          |> Enum.map(&Task.await(&1))

        assert result == List.duplicate("+PONG\r\n", times)
      end
    end

    test "echoes client" do
      start_portunus do
        assert send_message(["ECHO", "hello there"]) == "$11\r\nhello there\r\n"
      end
    end

    test "takes a lock" do
      start_portunus do
        assert send_message(["LOCK", "myhash"]) == "+OK\r\n"
        assert send_message(["EXISTS", "myhash"]) == "+OK\r\n"
        assert send_message(["EXISTS", "nohash"]) == "-ERR\r\n"
      end
    end

    test "releases a lock" do
      start_portunus do
        assert send_message(["LOCK", "myhash"]) == "+OK\r\n"
        assert send_message(["RELEASE", "myhash"]) == "+OK\r\n"
        # assert send_message(["EXISTS", "nohash"]) == "-ERR\r\n"
      end
    end
  end
end
