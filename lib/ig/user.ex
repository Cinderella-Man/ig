defmodule Ig.User do
  @moduledoc """
  User represents single login details and does all
  the heavy lifting for Ig process and holds all account
  related informations in it's state:

  ```
  defstruct [
      demo: false,
      identifier: nil,
      password: nil,
      api_key: nil,
      cst: nil,
      security_token: nil,
      account_type: nil,
      account_info: %{},
      currency_iso_code: nil,
      currency_symbol: nil,
      current_account_id: nil,
      lightstreamer_endpoint: nil,
      accounts: [],
      client_id: nil,
      timezone_offset: 0,
      has_active_demo_accounts: true,
      has_active_live_accounts: true,
      trailing_stops_enabled: false,
      rerouting_environment: null,
      dealing_enabled: true
  ]
  ```
  """

  use GenServer

  defmodule State do
    defstruct demo: false,
              identifier: nil,
              password: nil,
              api_key: nil,
              cst: nil,
              security_token: nil,
              account_type: nil,
              account_info: %{},
              currency_iso_code: nil,
              currency_symbol: nil,
              current_account_id: nil,
              lightstreamer_endpoint: nil,
              accounts: [],
              client_id: nil,
              timezone_offset: 0,
              has_active_demo_accounts: true,
              has_active_live_accounts: true,
              trailing_stops_enabled: false,
              rerouting_environment: nil,
              dealing_enabled: true

    use ExConstructor
  end

  def start_link(arguments, options \\ []) do
    GenServer.start_link(__MODULE__, arguments, options)
  end

  def init(account_details) do
    {:ok, State.new(account_details)}
  end

  def login(pid) do
    GenServer.call(pid, :login)
  end

  def get_state(pid) when is_pid(pid) do
    GenServer.call(pid, :get_state)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:login, _from, %State{identifier: identifier, password: password, api_key: api_key, demo: demo}) do
    {:ok, %HTTPoison.Response{body: body, headers: response_headers}} =
      Ig.HTTPClient.post(demo, '/session', %{identifier: identifier, password: password}, [
        {"X-IG-API-KEY", api_key}
      ])

    response_body = Jason.decode!(body)

    new_state = %State{
      demo: demo,
      identifier: identifier,
      password: password,
      api_key: api_key,
      cst: Enum.find(response_headers, nil, &(elem(&1, 0) == "CST")) |> elem(1),
      security_token: Enum.find(response_headers, nil, &(elem(&1, 0) == "X-SECURITY-TOKEN")) |> elem(1),
      account_type: Map.fetch!(response_body, "accountType"),
      account_info: Map.fetch!(response_body, "accountInfo"),
      currency_iso_code: Map.fetch!(response_body, "currencyIsoCode"),
      currency_symbol: Map.fetch!(response_body, "currencySymbol"),
      current_account_id: Map.fetch!(response_body, "currentAccountId"),
      lightstreamer_endpoint: Map.fetch!(response_body, "lightstreamerEndpoint"),
      accounts: Map.fetch!(response_body, "accounts"),
      client_id: Map.fetch!(response_body, "clientId"),
      timezone_offset: Map.fetch!(response_body, "timezoneOffset"),
      has_active_demo_accounts: Map.fetch!(response_body, "hasActiveDemoAccounts"),
      has_active_live_accounts: Map.fetch!(response_body, "hasActiveLiveAccounts"),
      trailing_stops_enabled: Map.fetch!(response_body, "trailingStopsEnabled"),
      rerouting_environment: Map.fetch!(response_body, "reroutingEnvironment"),
      dealing_enabled: Map.fetch!(response_body, "dealingEnabled"),
    }

    {:reply, new_state, new_state}
  end
end
