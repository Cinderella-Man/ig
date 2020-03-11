defmodule Ig.Transaction do
  @moduledoc """
  Struct for representing a transactions returned by /history/transactions
  ```
  defstruct [
    :cashTransaction,
    :closeLevel,
    :currency,
    :date,
    :dateUtc,
    :instrumentName,
    :openDateUtc,
    :openLevel,
    :period,
    :profitAndLoss,
    :reference,
    :size,
    :transactionType
  ]
  ```
  """

  defstruct [
    :cashTransaction,
    :closeLevel,
    :currency,
    :date,
    :dateUtc,
    :instrumentName,
    :openDateUtc,
    :openLevel,
    :period,
    :profitAndLoss,
    :reference,
    :size,
    :transactionType
  ]

  use ExConstructor
end
