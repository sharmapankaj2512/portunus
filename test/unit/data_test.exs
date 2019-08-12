defmodule DataTest do
  use ExUnit.Case

  import Portunus.Data, only: [unmarshal: 1]

  describe "Portunus.Data" do
    import TestHelpers, only: [format_message: 1]

    test "unmarshals raw commands" do
      data = [
        {"READY", "ready"},
        {"PING", "ping"}
      ]

      for {command, expected} <- data do
        raw = format_message(command)
        assert unmarshal(raw) == expected
      end
    end
  end
end
