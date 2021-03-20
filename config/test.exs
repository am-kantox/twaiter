import Config

config :twaiter,
  third_parties: [],
  impls: [{Twaiter.Mastodon, Twaiter.Mocks.ThirdParty}]
