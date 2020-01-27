defmodule Ig.Account do
  @moduledoc """
  Struct for representing a single account returned by /accounts
  ```
  defstruct [
    :account_alias,
    :account_id,
    :account_name,
    :account_type,
    :balance,
    :can_transfer_from,
    :can_transfer_to,
    :currency,
    :preferred,
    :status
  ]
  ```
  """

  defstruct [
    :account_alias,
    :account_id,
    :account_name,
    :account_type,
    :balance,
    :can_transfer_from,
    :can_transfer_to,
    :currency,
    :preferred,
    :status
  ]

  use ExConstructor
end
