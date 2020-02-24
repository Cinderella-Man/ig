defmodule Ig.HistoricalActivityDetail do
  @moduledoc """
  Struct for representing nested data returned by /history/activity
  ```
  defstruct [
    :actions,
    :currency,
    :dealReference,
    :direction,
    :goodTillDate,
    :guaranteedStop,
    :level,
    :limitDistance,
    :limitLevel,
    :marketName,
    :size,
    :stopDistance,
    :stopLevel,
    :trailingStep,
    :trailingStopDistance
  ]
  ```
  """

  defstruct [
    :actions,
    :currency,
    :dealReference,
    :direction,
    :goodTillDate,
    :guaranteedStop,
    :level,
    :limitDistance,
    :limitLevel,
    :marketName,
    :size,
    :stopDistance,
    :stopLevel,
    :trailingStep,
    :trailingStopDistance
  ]

  use ExConstructor
end
