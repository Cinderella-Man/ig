defmodule Ig.AccountPreference do
  @moduledoc """
  Struct for representing account preferences returned by /accounts/preferences
  ```
  defstruct [
    :trailingStopsEnabled
  ]
  ```
  """

  defstruct [
    :trailing_stops_enabled
  ]

  use ExConstructor
end
