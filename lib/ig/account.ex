defmodule Ig.Account do
  @moduledoc """
  Struct for representing a IG account informations

  ```
  defstruct [
    demo: false,
    identifier: nil,
    password: nil,
    api_key: nil,
    cst: nil,
    security_token: nil,
    lightstreamer_url: nil
  ]
  ```
  """
  # @enforce_keys [:identifier, :password, :api_key, :demo]
  defstruct demo: false,
            identifier: nil,
            password: nil,
            api_key: nil,
            cst: nil,
            security_token: nil,
            lightstreamer_url: nil

  use ExConstructor

  def login(%__MODULE__{identifier: identifier, password: password, api_key: api_key, demo: demo}) do
    # WORK IN PROGRESS
    # Ig.HttpClient.post('/') 
  end
end
