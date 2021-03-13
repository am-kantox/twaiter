defmodule Twaiter.ThirdParty do
  @doc "Connect to the third party"
  @callback connect(input :: map()) :: :ok | {:error, any()}

  @doc "Perform request to the third party"
  @callback call(input :: String.t()) :: String.t()
end
