defmodule IgTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Ig

  setup_all do
    HTTPoison.start()
  end

  test "login using default(first) user" do
    use_cassette "login_ok" do
      assert Ig.login() == %Ig.User.State{
        account_info: %{
          "available" => 6031.0,
          "balance" => 7640.0,
          "deposit" => 6209.0,
          "profitLoss" => 4600.0
        },
        account_type: "SPREADBET",
        accounts: [
          %{
            "accountId" => "EDCBA",
            "accountName" => "Demo-cfd",
            "accountType" => "CFD",
            "preferred" => false
          },
          %{
            "accountId" => "ABCDE",
            "accountName" => "Demo-SpreadBet",
            "accountType" => "SPREADBET",
            "preferred" => true
          }
        ],
        api_key: "IAG5JPWraNvGDI5sokzy",
        client_id: "101111111",
        cst: "***",
        currency_iso_code: "GBP",
        currency_symbol: "£",
        current_account_id: "ABCDE",
        dealing_enabled: true,
        demo: true,
        has_active_demo_accounts: true,
        has_active_live_accounts: true,
        identifier: "MyUser",
        lightstreamer_endpoint: "https://demo-apd.marketdatasystems.com",
        password: "mySecretPassword",
        rerouting_environment: nil,
        security_token: "***",
        timezone_offset: 0,
        trailing_stops_enabled: false
      }
    end
  end
end
