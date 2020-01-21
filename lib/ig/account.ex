defmodule Ig.Account do
  @moduledoc """
  Account does heavy lifting for Ig process and holds all
  account related informations in it's state:

  ```
  defstruct [
    demo: false,
    identifier: nil,
    password: nil,
    api_key: nil,
    cst: nil,
    security_token: nil,
    lightstreamer_url: nil
  ]
  ```
  """

  use GenServer

  defmodule State do
    # @enforce_keys [:identifier, :password, :api_key, :demo]
    defstruct demo: false,
              identifier: nil,
              password: nil,
              api_key: nil,
              cst: nil,
              security_token: nil,
              lightstreamer_url: nil

    use ExConstructor
  end

  def start_link(arguments, options \\ []) do
    GenServer.start_link(__MODULE__, arguments, options)
  end

  def init(%{identifier: identifier, password: password, api_key: api_key, demo: demo}) do
    {:ok, %HTTPoison.Response{body: body, headers: response_headers}} =
      Ig.HTTPClient.post(demo, '/session', %{identifier: identifier, password: password}, [
        {"X-IG-API-KEY", api_key}
      ])

    response_body = Jason.decode!(body)

    {:ok, %State{
      identifier: identifier,
      password: password,
      api_key: api_key,
      demo: demo,
      cst: Enum.find(response_headers, nil, &(elem(&1, 0) == "CST")),
      security_token: Enum.find(response_headers, nil, &(elem(&1, 0) == "X-SECURITY-TOKEN")),
      lightstreamer_url: Map.fetch!(response_body, "lightstreamerEndpoint")
    }}
  end

  def get_state(pid) when is_pid(pid) do
    GenServer.call(pid, :get_state)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
end
