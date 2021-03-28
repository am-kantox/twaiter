defmodule Twaiter.ThirdParty.State do
  @moduledoc false
  defstruct users: []

  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def state,
    do: GenServer.call(__MODULE__, :state)

  @impl GenServer
  def init(state) do
    {:ok, Map.new(state)}
  end

  @impl GenServer
  def handle_call(:state, _from, state) do
    {:reply, state}
  end
end
