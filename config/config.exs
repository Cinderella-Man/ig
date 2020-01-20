# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :ig,
  accounts: %{
    account_name: %{
      identifier: "...",
      password: "...",
      api_key: "...",
      demo: false
    }
  }

config :exvcr,
  filter_request_headers: [
    "CST",
    "X-SECURITY-TOKEN"
  ]
