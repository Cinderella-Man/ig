defmodule Ig.HistoricalActivity do
  @moduledoc """
  Struct for representing data returned by /history/activity
  ```
  defstruct [
    :channel,
    :date,
    :dealId,
    :description,
    :details,
    :epic,
    :period,
    :status,
    :type
  ]
  ```
  """

  defstruct [
    :channel,
    :date,
    :dealId,
    :description,
    :details,
    :epic,
    :period,
    :status,
    :type
  ]

  use ExConstructor
end
