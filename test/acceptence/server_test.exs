defmodule ServerTest do
  use ExUnit.Case
  require Logger

  import TestHelpers, only: [send_message: 1, start_portunus: 1]

  describe "Portunus.Server" do
    test "responds to ping" do
      start_portunus do
        assert send_message("PING") == "+PONG/r/n"
      end
    end
  end
end
