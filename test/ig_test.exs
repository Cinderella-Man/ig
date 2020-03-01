defmodule IgTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Ig

  setup_all do
    HTTPoison.start()
  end

  test "login using default(first) user" do
    use_cassette "login_ok" do
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, result} = Ig.User.login(user_pid)
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
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, _} = Ig.User.login(user_pid)

      assert Ig.User.accounts(user_pid) ==
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
                      "available" => 16980.0,
                      "balance" => 16980.0,
                      "deposit" => 0.0,
                      "profitLoss" => 0.0
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
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, _} = Ig.User.login(user_pid)

      assert Ig.User.account_preferences(user_pid) ==
               {:ok,
                %Ig.AccountPreference{
                  trailing_stops_enabled: false
                }}
    end
  end

  test "fetch historical activities" do
    use_cassette "historical_activities" do
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, _} = Ig.User.login(user_pid)

      {:ok, result} =
        Ig.User.activity_history(user_pid, from: "2020-01-01T00:00:00", detailed: true)

      assert result.metadata.paging.next == nil
      assert result.metadata.paging.size == 4

      assert result.activities == [
               %Ig.HistoricalActivity{
                 channel: "MOBILE",
                 date: "2020-02-18T14:27:28",
                 dealId: "DIAAAADC3TV43AN",
                 description: "Rejected: 11",
                 details: %Ig.HistoricalActivityDetail{
                   actions: [],
                   currency: "GBP",
                   dealReference: "7RVM7N1E1CB3JSC",
                   direction: "SELL",
                   goodTillDate: nil,
                   guaranteedStop: false,
                   level: 77885,
                   limitDistance: nil,
                   limitLevel: nil,
                   marketName: "Tesla Inc (DE)",
                   size: 10000,
                   stopDistance: nil,
                   stopLevel: nil,
                   trailingStep: nil,
                   trailingStopDistance: nil
                 },
                 epic: "ED.D.TL0GY.DAILY.IP",
                 period: "DFB",
                 status: "REJECTED",
                 type: "POSITION"
               },
               %Ig.HistoricalActivity{
                 channel: "MOBILE",
                 date: "2020-02-18T14:26:12",
                 dealId: "DIAAAADC3U343AG",
                 description: "Position/s closed: BDRWS2A4",
                 details: %Ig.HistoricalActivityDetail{
                   actions: [
                     %{
                       "actionType" => "POSITION_CLOSED",
                       "affectedDealId" => "DIAAAADBDRWS2A4"
                     }
                   ],
                   currency: "GBP",
                   dealReference: "7RVM7N1E1CB21WH",
                   direction: "BUY",
                   goodTillDate: nil,
                   guaranteedStop: false,
                   level: 5643,
                   limitDistance: nil,
                   limitLevel: nil,
                   marketName: "Oil - Brent Crude",
                   size: 10,
                   stopDistance: nil,
                   stopLevel: nil,
                   trailingStep: nil,
                   trailingStopDistance: nil
                 },
                 epic: "EN.D.LCO.Month6.IP",
                 period: "APR-20",
                 status: "ACCEPTED",
                 type: "POSITION"
               },
               %Ig.HistoricalActivity{
                 channel: "SYSTEM",
                 date: "2020-01-29T20:14:54",
                 dealId: "DIAAAADBDRWS2A4",
                 description: "Position rolled: BDRWS2A4",
                 details: %Ig.HistoricalActivityDetail{
                   actions: [
                     %{
                       "actionType" => "POSITION_ROLLED",
                       "affectedDealId" => "DIAAAADBDRWS2A4"
                     }
                   ],
                   currency: "GBP",
                   dealReference: nil,
                   direction: "SELL",
                   goodTillDate: nil,
                   guaranteedStop: false,
                   level: 5888,
                   limitDistance: nil,
                   limitLevel: nil,
                   marketName: "Oil - Brent Crude",
                   size: 10,
                   stopDistance: nil,
                   stopLevel: nil,
                   trailingStep: nil,
                   trailingStopDistance: nil
                 },
                 epic: "EN.D.LCO.Month6.IP",
                 period: "APR-20",
                 status: "ACCEPTED",
                 type: "POSITION"
               },
               %Ig.HistoricalActivity{
                 channel: "SYSTEM",
                 date: "2020-01-29T20:14:54",
                 dealId: "DIAAAADBDRWSZA4",
                 description: "Position/s closed: 8UC2QXAU",
                 details: %Ig.HistoricalActivityDetail{
                   actions: [
                     %{
                       "actionType" => "POSITION_CLOSED",
                       "affectedDealId" => "DIAAAAC8UC2QXAU"
                     }
                   ],
                   currency: "GBP",
                   dealReference: nil,
                   direction: "BUY",
                   goodTillDate: nil,
                   guaranteedStop: false,
                   level: 5984,
                   limitDistance: nil,
                   limitLevel: nil,
                   marketName: "Oil - Brent Crude",
                   size: 10,
                   stopDistance: nil,
                   stopLevel: nil,
                   trailingStep: nil,
                   trailingStopDistance: nil
                 },
                 epic: "EN.D.LCO.Month5.IP",
                 period: "MAR-20",
                 status: "ACCEPTED",
                 type: "POSITION"
               }
             ]
    end
  end

  test "fetch historical activities by date range" do
    use_cassette "historical_activities_date_range" do
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, _} = Ig.User.login(user_pid)

      {:ok, result} = Ig.User.activity_history(user_pid, "01-01-2020", "19-02-2020")

      assert result.activities == [
               %Ig.HistoricalActivity{
                 channel: "Mobile",
                 date: "18/02/20",
                 dealId: "DIAAAADC3TV43AN",
                 description: nil,
                 details: nil,
                 epic: "ED.D.TL0GY.DAILY.IP",
                 period: "DFB",
                 status: nil,
                 type: nil
               },
               %Ig.HistoricalActivity{
                 channel: "Mobile",
                 date: "18/02/20",
                 dealId: "DIAAAADC3U343AG",
                 description: nil,
                 details: nil,
                 epic: "EN.D.LCO.Month6.IP",
                 period: "APR-20",
                 status: nil,
                 type: nil
               },
               %Ig.HistoricalActivity{
                 channel: "System",
                 date: "29/01/20",
                 dealId: "DIAAAADBDRWS2A4",
                 description: nil,
                 details: nil,
                 epic: "EN.D.LCO.Month6.IP",
                 period: "APR-20",
                 status: nil,
                 type: nil
               },
               %Ig.HistoricalActivity{
                 channel: "System",
                 date: "29/01/20",
                 dealId: "DIAAAADBDRWSZA4",
                 description: nil,
                 details: nil,
                 epic: "EN.D.LCO.Month5.IP",
                 period: "MAR-20",
                 status: nil,
                 type: nil
               }
             ]
    end
  end

  test "fetch historical activities by last period" do
    use_cassette "historical_activities_last_period" do
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, _} = Ig.User.login(user_pid)

      {:ok, result} = Ig.User.activity_history(user_pid, 5_000_000_000)

      assert result.activities == [
               %Ig.HistoricalActivity{
                 channel: "Mobile",
                 date: "18/02/20",
                 dealId: "DIAAAADC3TV43AN",
                 description: nil,
                 details: nil,
                 epic: "ED.D.TL0GY.DAILY.IP",
                 period: "DFB",
                 status: nil,
                 type: nil
               },
               %Ig.HistoricalActivity{
                 channel: "Mobile",
                 date: "18/02/20",
                 dealId: "DIAAAADC3U343AG",
                 description: nil,
                 details: nil,
                 epic: "EN.D.LCO.Month6.IP",
                 period: "APR-20",
                 status: nil,
                 type: nil
               },
               %Ig.HistoricalActivity{
                 channel: "System",
                 date: "29/01/20",
                 dealId: "DIAAAADBDRWS2A4",
                 description: nil,
                 details: nil,
                 epic: "EN.D.LCO.Month6.IP",
                 period: "APR-20",
                 status: nil,
                 type: nil
               },
               %Ig.HistoricalActivity{
                 channel: "System",
                 date: "29/01/20",
                 dealId: "DIAAAADBDRWSZA4",
                 description: nil,
                 details: nil,
                 epic: "EN.D.LCO.Month5.IP",
                 period: "MAR-20",
                 status: nil,
                 type: nil
               }
             ]
    end
  end
end
