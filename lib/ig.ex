defmodule Ig do
  @moduledoc """
  Public interface for using IG Api's wrapper.

  It expects following config:
  ```
  config :ig,
    accounts: %{
      account_name: %{
        identifier: "...",
        password: "...",
        api_key: "...",
        demo: false
      }
    }
  ```
  where:
  - `account_name` is a human readable reference that will be used
  to point which account should be used (it can be any valid atom)
  - `identifier` is your username
  - `api_key` can be obtained from "My Account" on IG's dealing platform
  - `demo` confirms is that a demo account 

  Idea behind config structured this way is that allows to easily use
  multiple accounts (for example to minimize the risk) just by referring
  to them using freely picked name.

  Ig implements GenServer and on start it will grab all of those and
  try to login using *all* of those accounts. It will hold generated tokens
  and allow you to use multiple accounts in parallel.

  """
  use GenServer

  defmodule State do
    defstruct accounts: []
  end

  ## Public interface

  @doc """
  Required for starting from mix
  """
  def start(_type, _args) do
    start_link(nil)
  end

  @spec start_link(any) :: GenServer.on_start()
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: :IG)
  end

  @spec init(any) :: {:ok, %State{}}
  def init(_) do
    state = %State{
      accounts:
        Enum.map(Application.get_env(:ig, :accounts) || [], &init_account/1) |> Enum.into(%{})
    }

    {:ok, state}
  end

  @spec fetch_accounts() :: %{atom => pid()}
  def fetch_accounts() do
    GenServer.call(:IG, :fetch_accounts)
  end

  ## Callbacks

  def handle_call(:fetch_accounts, _from, state) do
    {:reply, state.accounts, state}
  end

  ## Private functions

  @type credential ::
          {:identifier, String.t()}
          | {:password, String.t()}
          | {:api_key, String.t()}
          | {:demo, boolean()}
  @spec init_account({atom(), [credential]}) :: {atom(), {:ok, pid()}}
  defp init_account({account_name, credentials}) do
    {:ok, pid} = Ig.Account.start_link(credentials, [name: account_name])
    {account_name, pid}
  end
end
