defmodule Ig.Position do
  @moduledoc """
  Struct for representing a positions returned by /positions
  ```
  defstruct [
    :contractSize,
    :controlledRisk,
    :createdDate,
    :createdDateUTC,
    :currency,
    :dealId,
    :dealReference,
    :direction,
    :level,
    :limitLevel,
    :limitedRiskPremium,
    :size,
    :stopLevel,
    :trailingStep,
    :trailingStopDistance
  ]
  ```
  """

  defstruct [
    :contractSize,
    :controlledRisk,
    :createdDate,
    :createdDateUTC,
    :currency,
    :dealId,
    :dealReference,
    :direction,
    :level,
    :limitLevel,
    :limitedRiskPremium,
    :size,
    :stopLevel,
    :trailingStep,
    :trailingStopDistance
  ]

  use ExConstructor
end
