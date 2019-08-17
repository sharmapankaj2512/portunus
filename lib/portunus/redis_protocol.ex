defmodule Portunus.RedisProtocol do
  @behaviour Portunus.Protocol
  require Logger

  import String, only: [downcase: 1]
  alias Portunus.Error, as: Error

  @impl Portunus.Protocol
  def marshal(data) when is_atom(data) do
    Atom.to_string(data)
    |> String.upcase
    |> (fn x -> "+#{x}\r\n" end).()
  end

  def marshal(%Error{message: message}) do
    "-ERR\r\n"
  end

  def marshal(data) do
    "$#{String.length(data)}\r\n#{data}\r\n"
  end

  @impl Portunus.Protocol
  def unmarshal(data) do
    # handle failure scenarions
    # what if * is not present
    # what if number of args is not present
    {:ok, [cmd | args]} =
      StringIO.open(data, [capture_prompt: false], fn pid ->
        if read_first(pid) == "*" do
          num_args = read_integer(pid)

          Enum.map(1..num_args, fn(_) ->
            if read_first(pid) == "$" do
              read_integer(pid)
              read_line(pid)
            end
          end)
        end
      end)
      [downcase(cmd) | args]
  end

  defp read_first(pid) do
    IO.getn(pid, "", 1)
  end

  defp read_integer(pid) do
    read_line(pid)
    |> String.to_integer()
  end

  defp read_line(pid) do
    IO.gets(pid, :line)
    |> String.trim()
  end
end
