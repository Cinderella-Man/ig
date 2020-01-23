# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :ig,
  users: %{
    user_name: %{
      identifier: "...",
      password: "...",
      api_key: "...",
      demo: true
    }
  }

config :exvcr,
  filter_request_headers: [
    "CST",
    "X-SECURITY-TOKEN"
  ]

# This file will be included for convinience gitignored
import_config "secret.exs"