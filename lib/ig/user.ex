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

  @doc """
  Returns the user's session details.

  Version: 1
  API Docs: https://labs.ig.com/rest-trading-api-reference/service-detail?id=534
  """
  def login(pid) do
    GenServer.call(pid, :login)
  end

  @doc """
  Returns a list of accounts belonging to the logged-in client.

  Version: 1
  API Docs: https://labs.ig.com/rest-trading-api-reference/service-detail?id=553
  """
  def accounts(pid) do
    GenServer.call(pid, :accounts)
  end

  @doc """
  Returns account preferences.

  Version: 1
  API Docs: https://labs.ig.com/rest-trading-api-reference/service-detail?id=531
  """
  def account_preferences(pid) do
    GenServer.call(pid, :account_preferences)
  end

  @doc """
  Returns the account activity history.

  Optional params:
  - from     (DateTime)	Start date
  - to       (DateTime)	End date (Default = current time. A date without time component refers to the end of that day.)
  - detailed (boolean) 	Indicates whether to retrieve additional details about the activity (default = false)
  - dealId   (String) 	Deal ID
  - filter   (String) 	FIQL filter (supported operators: ==|!=|,|;)
  - pageSize (int) 	    Page size (min: 10, max: 500) (Default = 50)

  Version: 1
  API Docs: https://labs.ig.com/rest-trading-api-reference/service-detail?id=543
  """
  @spec activity_history(pid(), [keyword()]) :: {:ok, %{}}
  def activity_history(pid, [_ | _] = optional_args) do
    GenServer.call(pid, {:activity_history, optional_args})
  end

  @doc """
  Returns the account activity history for the last specified period.

  last_period is an interval in milliseconds

  Version: 1
  API Docs: https://labs.ig.com/rest-trading-api-reference/service-detail?id=549
  """
  @spec activity_history(pid(), integer()) :: {:ok, %{}}
  def activity_history(pid, last_period) when is_integer(last_period) do
    GenServer.call(pid, {:activity_history, last_period})
  end

  @doc """
  Returns the account activity history for the given date range.

  Both from_date and to_date should be string in dd-mm-yyyy format

  Version: 1
  API Docs: https://labs.ig.com/rest-trading-api-reference/service-detail?id=539
  """
  @spec activity_history(pid(), String.t(), String.t()) :: {:ok, %{}}
  def activity_history(pid, from_date, to_date) do
    # todo: check dd-mm-yyyy format here
    GenServer.call(pid, {:activity_history, from_date, to_date})
  end

  @doc """
  Returns the transaction history. By default returns the minute prices within the last 10 minutes.

  Optional params:
  - type           (String)   Transaction type ALL | ALL_DEAL | DEPOSIT | WITHDRAWAL (default = ALL)
  - from           (DateTime) Start date
  - to             (DateTime) End date (date without time refers to the end of that day)
  - maxSpanSeconds (int) 	    Limits the timespan in seconds through to current time (not applicable if a date range has been specified) (default = 600)
  - pageSize       (int)      Page size (disable paging = 0) (default = 20)
  -	pageNumber     (int)      Page number (default = 1)

  Version: 2
  API Docs: https://labs.ig.com/rest-trading-api-reference/service-detail?id=525
  """
  @spec transactions(pid(), [keyword()]) :: {:ok, %{}}
  def transactions(pid, [_ | _] = optional_args) do
    GenServer.call(pid, {:transactions, optional_args})
  end

  def get_state(pid) when is_pid(pid) do
    GenServer.call(pid, :get_state)
  end

  ## Callbacks

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

  def handle_call(
        {:activity_history, [_ | _] = optional_args},
        _from,
        %State{cst: cst, api_key: api_key, demo: demo, security_token: security_token} = state
      ) do
    params = URI.encode_query(optional_args)

    {:ok, %HTTPoison.Response{body: body}} =
      Ig.RestClient.get(demo, "/history/activity?#{params}", [
        {"X-IG-API-KEY", api_key},
        {"X-SECURITY-TOKEN", security_token},
        {"CST", cst},
        {"VERSION", 3}
      ])

    result =
      body
      |> decode_activities()

    {:reply, {:ok, result}, state}
  end

  def handle_call(
        {:activity_history, from_date, to_date},
        _from,
        %State{cst: cst, api_key: api_key, demo: demo, security_token: security_token} = state
      ) do
    {:ok, %HTTPoison.Response{body: body}} =
      Ig.RestClient.get(demo, "/history/activity/#{from_date}/#{to_date}", [
        {"X-IG-API-KEY", api_key},
        {"X-SECURITY-TOKEN", security_token},
        {"CST", cst},
        {"VERSION", 1}
      ])

    %{"activities" => activities_list} =
      body
      |> Jason.decode!()

    result = %{
      activities:
        activities_list
        |> Enum.map(&decode_activity/1)
    }

    {:reply, {:ok, result}, state}
  end

  def handle_call(
        {:activity_history, last_period},
        _from,
        %State{cst: cst, api_key: api_key, demo: demo, security_token: security_token} = state
      )
      when is_integer(last_period) do
    {:ok, %HTTPoison.Response{body: body}} =
      Ig.RestClient.get(demo, "/history/activity/#{last_period}", [
        {"X-IG-API-KEY", api_key},
        {"X-SECURITY-TOKEN", security_token},
        {"CST", cst},
        {"VERSION", 1}
      ])

    %{"activities" => activities_list} =
      body
      |> Jason.decode!()

    result = %{
      activities:
        activities_list
        |> Enum.map(&decode_activity/1)
    }

    {:reply, {:ok, result}, state}
  end

  defp decode_activities(body) do
    %{
      "activities" => activities_list,
      "metadata" => %{
        "paging" => %{
          "next" => paging_next,
          "size" => paging_size
        }
      }
    } = Jason.decode!(body)

    %{
      activities:
        activities_list
        |> Enum.map(&decode_activity/1),
      metadata: %{paging: %{next: paging_next, size: paging_size}}
    }
  end

  #####
  # Note: Activities can have no `details`
  #####
  defp decode_activity(activity) do
    activity_struct = Ig.HistoricalActivity.new(activity)

    activity_details =
      case activity_struct.details do
        nil -> nil
        details -> Ig.HistoricalActivityDetail.new(details)
      end

    %{activity_struct | details: activity_details}
  end
end
