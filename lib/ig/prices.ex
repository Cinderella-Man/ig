defmodule Ig.Prices do
  @moduledoc """
  Struct for representing a single price returned by /prices
  ```
  defstruct [
   :snapshotTime,
    :snapshotTimeUTC,
    :openPrice,
    :closePrice,
    :lowPrice,
    :highPrice,
    :lastTradedVolume
  ]
  ```
  """
  defstruct [
    :snapshotTime,
    :snapshotTimeUTC,
    :openPrice,
    :closePrice,
    :lowPrice,
    :highPrice,
    :lastTradedVolume
  ]

  use ExConstructor
end