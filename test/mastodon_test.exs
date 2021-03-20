defmodule Twaiter.Tests.Mastodon do
  use ExUnit.Case

  import Mox

  setup :set_mox_from_context
  setup :verify_on_exit!

  test "connects and posts statuses happily" do
    Twaiter.Mocks.ThirdParty
    |> expect(:connect, fn %{} -> :ok end)
    |> expect(:call, fn message, :ok -> {:first, message} end)

    {:ok, _pid} = Twaiter.Mastodon.start_link()

    assert Twaiter.Mastodon.post("Hello") == {:first, "Hello"}
  end

  test "connects and posts statuses happily again" do
    Twaiter.Mocks.ThirdParty
    |> expect(:connect, fn %{} -> :ok end)
    |> expect(:call, fn message, :ok -> {:second, message} end)

    {:ok, _pid} = Twaiter.Mastodon.start_link()

    assert Twaiter.Mastodon.post("Hello") == {:second, "Hello"}
  end
end
