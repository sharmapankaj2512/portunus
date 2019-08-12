defmodule Portunus.Data do
  import String, only: [downcase: 1]

  def unmarshal(data) do
    # handle failure scenarions
    # what if * is not present
    # what if number of args is not present
    {:ok, result} =
      StringIO.open(data, [capture_prompt: false], fn pid ->
        if IO.getn(pid, "", 1) == "*" do
          num_args = String.to_integer(IO.getn(pid, "", 1))

          for _i <- 1..num_args do
            # /r/n
            IO.getn(pid, "", 2)
            len = String.to_integer(IO.getn(pid, "", 1))
            # /r/n
            IO.getn(pid, "", 2)
            IO.getn(pid, "", len)
          end
        end
      end)

    downcase(hd(result))
  end
end
