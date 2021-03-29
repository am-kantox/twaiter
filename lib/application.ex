defmodule Twaiter.Application do
  @moduledoc false

  use Application

  @spec start(Application.app(), Application.restart_type()) ::
          {:error, any()} | {:ok, pid()} | {:ok, pid(), any()}
  def start(_type, _args) do
    children = [
      Twaiter.ThirdPartiesSupervisor
    ]

    opts = [strategy: :one_for_one, name: Twaiter.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
