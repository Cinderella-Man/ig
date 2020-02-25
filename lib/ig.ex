defmodule Ig do
  @moduledoc """
  Public interface for using IG Api's wrapper.

  It expects following config:
  ```
  config :ig,
    users: %{
      user_name: %{
        identifier: "...",
        password: "...",
        api_key: "...",
        demo: false
      }
    }
  ```
  where:
  - `user_name` is a human readable reference that will be used
  to point which user should be used (it can be any valid atom)
  - `identifier` is your username
  - `api_key` can be obtained from "My Account" on IG's dealing platform
  - `demo` confirms is that a demo account 

  Idea behind config structured this way is that allows to easily use
  multiple accounts (for example to minimize the risk) just by referring
  to them using freely picked name.

  To clarify - account is a whole user profile with assigned email. For 
  example two accounts would mean that you use two completely seperate
  profile with diffent login details, personal details etc. This can be
  beneficial when for example one account is classified as "professional
  trader" (with high margins available but without many safety gates) and
  other one is retail customer (higher premiums but safety features).
  It can also be used to mitigate increased margins when trading high volumes.

  To sum up:
  - account - single per person, you log in with it
  - subaccount - listed as "accounts" in My IG

  Ig holds spins further server per account and acts as a gateway to execute
  any function on the account. It allows you to use multiple accounts in
  parallel.

  """
  use GenServer

  defmodule State do
    defstruct users: []
  end

  ## Public interface

  def start(_type, _args) do
    start_link([name: :IG])
  end

  @spec start_link(any) :: GenServer.on_start()
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, nil, opts)
  end

  @spec init(any) :: {:ok, %State{}}
  def init(_) do
    users =
      Enum.map(
        Application.get_env(:ig, :users) || [],
        &init_account/1
      )
      |> Enum.into(%{})

    {:ok,
     %State{
       users: users
     }}
  end

  @spec get_users(pid()) :: %{atom => pid()}
  def get_users(pid \\ :IG) do
    GenServer.call(pid, :get_users)
  end

  def get_user(user, pid \\ :IG) do
    GenServer.call(pid, {:get_user, user})
  end

  ## Callbacks

  def handle_call(:get_users, _from, state) do
    {:reply, state.users, state}
  end

  def handle_call({:get_user, user}, _from, state) do
    {:reply, state.users[user], state}
  end

  ## Private functions

  @type credential ::
          {:identifier, String.t()}
          | {:password, String.t()}
          | {:api_key, String.t()}
          | {:demo, boolean()}
  @spec init_account({atom(), [credential]}) :: {atom(), {:ok, pid()}}
  defp init_account({user, credentials}) do
    {:ok, pid} = Ig.User.start_link(credentials, name: :"user-#{user}")
    {user, pid}
  end
end
