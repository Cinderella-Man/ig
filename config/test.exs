use Mix.Config

config :ig,
  users: %{
    user_name: %{
      identifier: "MyUser",
      password: "mySecretPassword",
      api_key: "IAG5JPWraNvGDI5sokzy",
      demo: true
    }
  }

config :exvcr,
  filter_request_headers: [
    "CST",
    "X-SECURITY-TOKEN",
    "X-IG-API-KEY"
  ]
