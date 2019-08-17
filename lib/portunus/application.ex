defmodule Portunus.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias Portunus.App, as: Portunus

  def start(_type, _args) do
    Portunus.listen(7878)
  end
end
