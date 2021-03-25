defmodule Twaiter.Mastodon do
  @moduledoc """
    Mastodon interoperation
  """
  use Twaiter.ThirdParty
end

defmodule Twaiter.Mastodon.Impl do
  @moduledoc false
  @behaviour Twaiter.ThirdParty

  @impl Twaiter.ThirdParty
  def connect(%{} = input) do
    base_url = Map.get(input, :base_url, System.get_env("BASE_URL", "https://mastodon.social"))

    input
    |> Map.get(:bearer_token, System.get_env("BEARER_TOKEN"))
    |> case do
      nil ->
        {:error, :missing_token}

      bearer_token when is_binary(bearer_token) ->
        {:ok, %Hunter.Client{base_url: base_url, bearer_token: bearer_token}}

      bearer_token ->
        {:error, {:invalid_token, bearer_token}}
    end
  end

  @impl Twaiter.ThirdParty
  def call(input, %Hunter.Client{} = state) when is_binary(input),
    do: call(%{message: input}, state)

  def call(%{message: message} = input, %Hunter.Client{} = state),
    do: Hunter.create_status(state, message, Map.get(input, :params, []))
end
