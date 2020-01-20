defmodule IgTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Ig

  setup_all do
    HTTPoison.start()
  end
end
