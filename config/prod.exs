import Config

config :camarero,
  cowboy: [
    port: 8443,
    scheme: :https,
    host: "pure-sands-60120.herokuapp.com",
    options: [
      port: String.to_integer(System.get_env("PORT", "8443")),
      force_ssl: [rewrite_on: [:x_forwarded_proto]]
    ]
  ]
