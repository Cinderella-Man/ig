defmodule Ig.Market do
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
    :otcTradeable,
    :percentageChange,
    :scalingFactor,
    :streamingPricesAvailable,
    :updateTime,
    :updateTimeUTC
  ]

  use ExConstructor
end
