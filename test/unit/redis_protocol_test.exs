defmodule ProtocolTest do
  use ExUnit.Case

  import Portunus.RedisProtocol, only: [unmarshal: 1, marshal: 1]

  describe "Portunus.RedisProtocol" do
    import TestHelpers, only: [format_message: 1]

    test "unmarshals protocol spec compatible text to raw commands" do
      data = [
        {"READY", "ready"},
        {"PING", "ping"}
      ]

      for {command, expected} <- data do
        raw = format_message(command)
        assert unmarshal(raw) == expected
      end
    end

    test "marshals text to protocol specs" do
      data = [{:ok, "+OK\r\n"}, {:ping, "+PING\r\n"}]
      for {text, expected} <- data do
        assert marshal(text) == expected
      end
    end
  end
end
