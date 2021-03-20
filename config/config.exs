import Config

config :twaiter,
  third_parties: [Twaiter.Mastodon],
  impls: [{Twaiter.Mastodon, Twaiter.Mastodon.Impl}]

if File.exists?(Path.join("config", "#{Mix.env()}.exs")),
  do: import_config("#{Mix.env()}.exs")
