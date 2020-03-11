defmodule Ig.Market do
  @moduledoc """
  Struct for representing a market part of positions returned by /positions
  ```
  defstruct [
    :bid,
    :delayTime,
    :epic,
    :expiry,
    :high,
    :instrumentName,
    :instrumentType,
    :lotSize,
    :low,
    :marketStatus,
    :netChange,
    :offer,
    :percentageChange,
    :scalingFactor,
    :streamingPricesAvailable,
    :updateTime,
    :updateTimeUTC
  ]
  ```
  """
  defstruct [
    :bid,
    :delayTime,
    :epic,
    :expiry,
    :high,
    :instrumentName,
    :instrumentType,
    :lotSize,
    :low,
    :marketStatus,
    :netChange,
    :offer,
    :percentageChange,
    :scalingFactor,
    :streamingPricesAvailable,
    :updateTime,
    :updateTimeUTC
  ]

  use ExConstructor
end
