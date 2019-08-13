defmodule Portunus.Data do
  import String, only: [downcase: 1]

  @spec marshal(atom) :: String
  def marshal(data) when is_atom(data) do
    Atom.to_string(data)
    |> String.upcase
    |> (fn x -> "+#{x}/r/n" end).()
  end

  @spec unmarshal(String) :: String
  def unmarshal(data) do
    # handle failure scenarions
    # what if * is not present
    # what if number of args is not present
    {:ok, result} =
      StringIO.open(data, [capture_prompt: false], fn pid ->
        if read_first(pid) == "*" do
          num_args = read_integer(pid)

          for _i <- 1..num_args do
            read_integer(pid)
            read_line(pid)
          end
        end
      end)

    downcase(hd(result))
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
