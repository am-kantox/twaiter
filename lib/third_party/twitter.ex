defmodule Twaiter.Twitter do
  @behaviour Twaiter.ThirdParty

  use GenServer

  def start_link(opts \\ []) do
    {name, opts} = Keyword.pop(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @impl GenServer
  def init(state) do
    state = Map.new(state)
    send(self(), :connect)
    {:ok, Map.put(state, :conn, nil)}
  end

  @impl GenServer
  def handle_info(:connect, state) do
    pid = connect(state)
    Process.monitor(pid)
    {:noreply, state}
  end

  def handle_info({:EXIT, _, _}, state) do
    send(self(), :connect)
    {:noreply, state}
  end

  @impl Twaiter.ThirdParty
  def connect(_input) do
  end

  @impl Twaiter.ThirdParty
  def call(_input) do
  end
end
