defmodule Twaiter do
  @moduledoc """
  Documentation for `Twaiter`.
  """

  use Camarero, as: Camarero, methods: ~w|post|a

  @impl Camarero.Plato
  def plato_put("login", %{"user" => user, "bearer_token" => token}) do
    our_token = 32 |> :crypto.strong_rand_bytes() |> :base64.encode()
    {:ok, _pid} = DynamicSupervisor.start_child(Twaiter.DynamicSupervisor,
      {Twaiter.Mastodon, [
        bearer_token: token,
        name: {:via, Registry, {Twaiter.Registry, {user, our_token}}}]})
    super(user, %{logged_in: DateTime.to_iso8601(DateTime.utc_now())})
    Jason.encode!(%{result: %{token: our_token}})
  end

  def plato_put("logout", %{"user" => user, "token" => token}) do
    case Registry.lookup(Twaiter.Registry, {user, token}) do
      [{pid, nil}] ->
        DynamicSupervisor.terminate_child(Twaiter.DynamicSupervisor, pid)
        super(user, %{logged_out: DateTime.to_iso8601(DateTime.utc_now())})
        Jason.encode!(%{result: :logged_out})
      _ ->
        {403, Jason.encode!(%{error: :invalid_user})}
    end
  end

  def plato_put("post", %{"user" => user, "token" => token, "text" => text}) do
    case plato_get(user) do
      {:ok, user_data} ->
        last_status = GenServer.call({:via, Registry, {Twaiter.Registry, {user, token}}}, {:post, text})
        super(user, Map.put(user_data, :last_status, last_status))
        Jason.encode!(%{last_post: DateTime.to_iso8601(DateTime.utc_now())})
      _ ->
        Jason.encode!(%{error: :invalid_user})
    end
  end
end
