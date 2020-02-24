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
  ],
  filter_sensitive_data: [
    [pattern: "\"password\":\"[a-zA-Z0-9_]+\"", placeholder: "\"password\":\"***\""],
    [pattern: "\"identifier\":\"[a-zA-Z0-9_]+\"", placeholder: "\"identifier\":\"***\""]
  ]
