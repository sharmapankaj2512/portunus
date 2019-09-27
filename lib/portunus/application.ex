defmodule Portunus.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Portunus.Locks, [:init]},
      {Portunus.App, [:listen]}
    ]

    opts = [strategy: :one_for_one, name: Portunus.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
