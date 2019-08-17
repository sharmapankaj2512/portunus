defmodule ProtocolTest do
  use ExUnit.Case
  require Logger

  import Portunus.RedisProtocol, only: [unmarshal: 1, marshal: 1]
  alias Portunus.Error, as: Error

  describe "Portunus.RedisProtocol" do
    import TestHelpers, only: [format_array: 1]

    test "unmarshals protocol spec compatible text to raw commands" do
      data = [
        {"READY", nil, ["ready"]},
        {"PING", nil, ["ping"]},
        {"ECHO", "hello there", ["echo", "hello there"]},
        {"LOCK", "myhash", ["lock", "myhash"]}
      ]

      for {command, message, expected} <- data do
        messages = Enum.filter([command, message], &(!is_nil(&1)))
        raw = format_array(messages)
        assert unmarshal(raw) == expected
      end
    end

    test "marshals text to protocol specs" do
      data = [
        {:ok, "+OK\r\n"},
        {:ping, "+PING\r\n"},
        {%Error{}, "-ERR\r\n"}
      ]

      for {text, expected} <- data do
        assert marshal(text) == expected
      end
    end
  end
end
