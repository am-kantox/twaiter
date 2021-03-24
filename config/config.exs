import Config

config :twaiter,
  third_parties: [Twaiter.Mastodon],
  impls: [{Twaiter.Mastodon, Twaiter.Mastodon.Impl}]

config :camarero,
  carta: [Camarero.Carta.Heartbeat, Twaiter],
  # catering: [
  #   max_restarts: 3,
  #   max_seconds: 5,
  #   max_children: :infinity,
  #   extra_arguments: []
  # ],
  root: "api/v1",
  cowboy: [port: 8080, scheme: :http, options: [port: 8080]]

config :logger, :console,
  format: "\n$message\n$date $time [$level] $metadata\n",
  level: :debug,
  metadata: [:file, :line, :handler, :endpoint, :cowboy]

if File.exists?(Path.join("config", "#{Mix.env()}.exs")),
  do: import_config("#{Mix.env()}.exs")
