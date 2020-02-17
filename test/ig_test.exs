defmodule IgTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Ig

  setup_all do
    HTTPoison.start()
  end

  test "login using default(first) user" do
    use_cassette "login_ok" do
      {:ok, pid} = Ig.start_link([])
      {:ok, result} = Ig.login(pid)
      result = %{result | identifier: "***", password: "***", api_key: "***"}

      assert result == %Ig.User.State{
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
               api_key: "***",
               client_id: "101111111",
               cst: "***",
               currency_iso_code: "GBP",
               currency_symbol: "£",
               current_account_id: "ABCDE",
               dealing_enabled: true,
               demo: true,
               has_active_demo_accounts: true,
               has_active_live_accounts: true,
               identifier: "***",
               lightstreamer_endpoint: "https://demo-apd.marketdatasystems.com",
               password: "***",
               rerouting_environment: nil,
               security_token: "***",
               timezone_offset: 0,
               trailing_stops_enabled: false
             }
    end
  end

  test "fetch accounts" do
    use_cassette "accounts" do
      {:ok, pid} = Ig.start_link([])
      {:ok, _state} = Ig.login(pid)

      assert Ig.accounts(pid) ==
               {:ok,
                [
                  %Ig.Account{
                    account_alias: nil,
                    account_id: "ZI5WH",
                    account_name: "Demo-cfd",
                    account_type: "CFD",
                    balance: %{
                      "available" => 1.0e4,
                      "balance" => 1.0e4,
                      "deposit" => 0.0,
                      "profitLoss" => 0.0
                    },
                    can_transfer_from: true,
                    can_transfer_to: true,
                    currency: "GBP",
                    preferred: false,
                    status: "ENABLED"
                  },
                  %Ig.Account{
                    account_alias: nil,
                    account_id: "ZI5WI",
                    account_name: "Demo-SpreadBet",
                    account_type: "SPREADBET",
                    balance: %{
                      "available" => 10416.0,
                      "balance" => 14530.0,
                      "deposit" => 5724.0,
                      "profitLoss" => 1610.0
                    },
                    can_transfer_from: true,
                    can_transfer_to: true,
                    currency: "GBP",
                    preferred: true,
                    status: "ENABLED"
                  }
                ]}
    end
  end

  test "fetch account preferences" do
    use_cassette "account_preferences" do
      {:ok, pid} = Ig.start_link([])
      {:ok, _state} = Ig.login(pid)

      assert Ig.account_preferences(pid) ==
               {:ok,
                %Ig.AccountPreference{
                  trailing_stops_enabled: false
                }}
    end
  end
end
