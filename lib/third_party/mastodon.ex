defmodule Twaiter.Mastodon do
  @behaviour Twaiter.ThirdParty

  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def post(input) do
    GenServer.call(__MODULE__, {:post, input})
  end

  @impl GenServer
  def init(state) do
    {:ok, Map.new(state), {:continue, :connect}}
  end

  @impl GenServer
  def handle_continue(:connect, state),
    do: {:noreply, connect(state)}

  @impl GenServer
  def handle_call({:post, input}, _from, state) do
    {:reply, call(input, state), state}
  end

  @impl Twaiter.ThirdParty
  def connect(%{} = input) do
    base_url = Map.get(input, :base_url, System.get_env("BASE_URL", "https://mastodon.social"))
    bearer_token = Map.get(input, :bearer_token, System.get_env("BEARER_TOKEN"))
    %Hunter.Client{base_url: base_url, bearer_token: bearer_token}
  end

  @impl Twaiter.ThirdParty
  def call(input, %Hunter.Client{} = state) when is_binary(input),
    do: call(%{message: input}, state)

  def call(%{message: message} = input, %Hunter.Client{} = state),
    do: Hunter.create_status(state, message, Map.get(input, :params, []))
end
