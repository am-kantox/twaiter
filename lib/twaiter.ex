defmodule Twaiter do
  @moduledoc """
  Documentation for `Twaiter`.
  """

  use Camarero, as: Camarero, methods: ~w|post|a

  @impl Camarero.Plato
  def plato_put("login", %{"user" => user, "bearer_token" => token}) do
    super(user, %{bearer_token: token})
  end

  def plato_put("logout", %{"user" => user}) do
    with {:ok, _} <- plato_delete(user),
         do: super(user, %{logged_out: DateTime.to_iso8601(DateTime.utc_now())})
  end

  def plato_put("post", %{"user" => user, "text" => text}) do
    with {:ok, user_data} <- plato_get(user) do
      Twaiter.Mastodon.login(user_data)
      last_status = Twaiter.Mastodon.post(text)
      super(user, Map.put(user_data, :last_status, last_status))
    end
  end
end
