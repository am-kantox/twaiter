defmodule Twaiter.ThirdParty do
  @moduledoc """
    Docs
  """

  @doc "Connect to the third party"
  @callback connect(input :: map()) :: {:ok, any()} | {:error, any()}

  @doc "Perform request to the third party"
  @callback call(input :: map(), state :: map()) :: any()

  @doc false
  defmacro __using__(opts \\ []) do
    quote generated: true, location: :keep do
      use GenServer

      require Logger

      @implementation Keyword.get(
                        unquote(opts),
                        :impl,
                        Application.get_env(:twaiter, :impls, [
                          {__MODULE__, Module.concat(__MODULE__, Impl)}
                        ])[__MODULE__]
                      )

      def start_link(opts \\ unquote(opts)) do
        GenServer.start_link(__MODULE__, opts, name: __MODULE__)
      end

      def login(credentials) do
        GenServer.cast(__MODULE__, {:connect, credentials})
      end

      def post(input) do
        GenServer.call(__MODULE__, {:post, input})
      end

      def state do
        GenServer.call(__MODULE__, :state)
      end

      @impl GenServer
      def init(state) do
        {:ok, Map.new(state), {:continue, :connect}}
      end

      @impl GenServer
      def handle_call(:state, {pid, _}, state) do
        send(pid, {:hey, self()})
        {:reply, {pid, state}, state}
      end

      @impl GenServer
      def handle_cast({:connect, credentials}, state) do
        credentials
        |> connect()
        |> case do
          {:ok, state} ->
            {:noreply, state}

          {:error, error} ->
            Logger.warn("Unable to connect. Reason: #{inspect(error)}")
            # {:noreply, state, {:continue, :connect}}
            {:noreply, state}
        end
      end

      @impl GenServer
      def handle_continue(:connect, state) do
        handle_cast({:connect, state}, state)
      end

      @impl GenServer
      def handle_call({:post, input}, _from, state) do
        {:reply, call(input, state), state}
      end

      @behaviour Twaiter.ThirdParty

      @impl Twaiter.ThirdParty
      defdelegate connect(input), to: @implementation

      @impl Twaiter.ThirdParty
      defdelegate call(input, state), to: @implementation
    end
  end
end
