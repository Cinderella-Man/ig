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

  def accounts(pid) do
    GenServer.call(pid, :accounts)
  end

  def account_preferences(pid) do
    GenServer.call(pid, :account_preferences)
  end

  def get_state(pid) when is_pid(pid) do
    GenServer.call(pid, :get_state)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:login, _from, %State{
        identifier: identifier,
        password: password,
        api_key: api_key,
        demo: demo
      }) do
    {:ok, result} = Ig.RestClient.login(demo, identifier, password, api_key)

    new_state = %{
      State.new(result)
      | identifier: identifier,
        password: password,
        api_key: api_key,
        demo: demo
    }

    {:reply, {:ok, new_state}, new_state}
  end

  def handle_call(
        :accounts,
        _from,
        %State{cst: cst, api_key: api_key, demo: demo, security_token: security_token} = state
      ) do
    {:ok, %HTTPoison.Response{body: body}} =
      Ig.RestClient.get(demo, '/accounts', [
        {"X-IG-API-KEY", api_key},
        {"X-SECURITY-TOKEN", security_token},
        {"CST", cst},
        {"VERSION", 1}
      ])

    response_body = Jason.decode!(body)

    accounts =
      response_body["accounts"]
      |> Enum.map(&Ig.Account.new/1)

    {:reply, {:ok, accounts}, state}
  end

  def handle_call(
        :account_preferences,
        _from,
        %State{cst: cst, api_key: api_key, demo: demo, security_token: security_token} = state
      ) do
    {:ok, %HTTPoison.Response{body: body}} =
      Ig.RestClient.get(demo, '/accounts/preferences', [
        {"X-IG-API-KEY", api_key},
        {"X-SECURITY-TOKEN", security_token},
        {"CST", cst},
        {"VERSION", 1}
      ])

    response_body = Jason.decode!(body)

    account_preference = Ig.AccountPreference.new(response_body)

    {:reply, {:ok, account_preference}, state}
  end
end
