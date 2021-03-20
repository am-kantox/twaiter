defmodule Twaiter.Mastodon do
  use Twaiter.ThirdParty
end

defmodule Twaiter.Mastodon.Impl do
  @behaviour Twaiter.ThirdParty

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
