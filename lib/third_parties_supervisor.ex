defmodule Twaiter.ThirdPartiesSupervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_) do
    children = [
      {DynamicSupervisor,
        strategy: :one_for_one, name: Twaiter.DynamicSupervisor},
      {Registry,
        keys: :unique, name: Twaiter.Registry}
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
