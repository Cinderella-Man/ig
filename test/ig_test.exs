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

  test "fetch historical transactions by date range" do
    use_cassette "historical_transactions_date_range" do
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, _} = Ig.User.login(user_pid)
      {:ok, result} =
        Ig.User.transactions(user_pid, from: "2019-10-01T00:00:00", to: "2020-03-01T00:00:00")

      assert result.metadata == %{
               page_data: %{page_number: 1, page_size: 20, total_pages: 1},
               size: 5
             }

      assert result.transactions == [
               %Ig.Transaction{
                 cashTransaction: false,
                 closeLevel: "5643",
                 currency: "£",
                 date: "2020-02-18",
                 dateUtc: "2020-02-18T14:26:12",
                 instrumentName: "Oil - Brent Crude",
                 openDateUtc: "2020-01-29T20:14:54",
                 openLevel: "5888",
                 period: "APR-20",
                 profitAndLoss: "£2,450.00",
                 reference: "DIAAAADBDRWS2A4",
                 size: "-10",
                 transactionType: "DEAL"
               },
               %Ig.Transaction{
                 cashTransaction: false,
                 closeLevel: "5984",
                 currency: "£",
                 date: "2020-01-29",
                 dateUtc: "2020-01-29T20:14:54",
                 instrumentName: "Oil - Brent Crude",
                 openDateUtc: "2019-12-26T20:10:56",
                 openLevel: "6673",
                 period: "MAR-20",
                 profitAndLoss: "£6,890.00",
                 reference: "DIAAAAC8UC2QXAU",
                 size: "-10",
                 transactionType: "DEAL"
               },
               %Ig.Transaction{
                 cashTransaction: false,
                 closeLevel: "6795",
                 currency: "£",
                 date: "2019-12-26",
                 dateUtc: "2019-12-26T20:10:56",
                 instrumentName: "Oil - Brent Crude",
                 openDateUtc: "2019-12-20T21:39:29",
                 openLevel: "6598",
                 period: "FEB-20",
                 profitAndLoss: "£-1,970.00",
                 reference: "DIAAAAC8HJHAGAQ",
                 size: "-10",
                 transactionType: "DEAL"
               },
               %Ig.Transaction{
                 cashTransaction: false,
                 closeLevel: "6561.5",
                 currency: "£",
                 date: "2019-12-17",
                 dateUtc: "2019-12-17T17:57:24",
                 instrumentName: "Oil - Brent Crude",
                 openDateUtc: "2019-12-17T17:17:56",
                 openLevel: "6541.5",
                 period: "DFB",
                 profitAndLoss: "£-300.00",
                 reference: "DIAAAAC74XU5BA8",
                 size: "-15",
                 transactionType: "DEAL"
               },
               %Ig.Transaction{
                 cashTransaction: false,
                 closeLevel: "0",
                 currency: "£",
                 date: "2019-12-17",
                 dateUtc: "2019-12-17T17:57:24",
                 instrumentName: "Oil - Brent Crude CRPREM DIAAAAC74XMARAR",
                 openDateUtc: "2019-12-17T17:57:24",
                 openLevel: "-",
                 period: "DFB",
                 profitAndLoss: "£-90.00",
                 reference: "CS2609523091576605444806232231432221",
                 size: "-",
                 transactionType: "WITH"
               }
             ]
    end
  end

  test "fetch currently active positions" do
    use_cassette "active_positions" do
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, _} = Ig.User.login(user_pid)
      {:ok, result} = Ig.User.positions(user_pid)

      assert result.positions == [
               %{
                 market: %Ig.Market{
                   bid: 3396.7,
                   delayTime: 0,
                   epic: "CC.D.CL.USS.IP",
                   expiry: "DFB",
                   high: 3528.2,
                   instrumentName: "Oil - US Crude",
                   instrumentType: "COMMODITIES",
                   lotSize: 1.0,
                   low: 3381.7,
                   marketStatus: "TRADEABLE",
                   netChange: -52.5,
                   offer: 3399.5,
                   percentageChange: -1.52,
                   scalingFactor: 1,
                   streamingPricesAvailable: true,
                   updateTime: "23:52:57",
                   updateTimeUTC: "23:52:57"
                 },
                 position: %Ig.Position{
                   contractSize: 1.0,
                   controlledRisk: true,
                   createdDate: "2020/03/10 23:33:48:000",
                   createdDateUTC: "2020-03-10T23:33:48",
                   currency: "GBP",
                   dealId: "DIAAAADE7N52VAP",
                   dealReference: "7RVM7N1E33CCPY1K",
                   direction: "SELL",
                   level: 3417.7,
                   limitLevel: nil,
                   limitedRiskPremium: 6.0,
                   size: 1.0,
                   stopLevel: 3447.7,
                   trailingStep: nil,
                   trailingStopDistance: nil
                 }
               },
               %{
                 market: %Ig.Market{
                   bid: 8765.9,
                   delayTime: 0,
                   epic: "CS.D.EURGBP.TODAY.IP",
                   expiry: "DFB",
                   high: 8774.5,
                   instrumentName: "EUR/GBP",
                   instrumentType: "CURRENCIES",
                   lotSize: 1.0,
                   low: 8730.3,
                   marketStatus: "TRADEABLE",
                   netChange: 27.0,
                   offer: 8767.9,
                   percentageChange: 0.31,
                   scalingFactor: 1,
                   streamingPricesAvailable: true,
                   updateTime: "23:52:56",
                   updateTimeUTC: "23:52:56"
                 },
                 position: %Ig.Position{
                   contractSize: 1.0,
                   controlledRisk: false,
                   createdDate: "2020/03/10 23:35:10:000",
                   createdDateUTC: "2020-03-10T23:35:10",
                   currency: "GBP",
                   dealId: "DIAAAADE7PDYNAT",
                   dealReference: "7RVM7N1E33CSPHRN",
                   direction: "BUY",
                   level: 8759.9,
                   limitLevel: 8780.9,
                   limitedRiskPremium: nil,
                   size: 1.0,
                   stopLevel: 8749.9,
                   trailingStep: nil,
                   trailingStopDistance: nil
                 }
               },
               %{
                 market: %Ig.Market{
                   bid: 10490.8,
                   delayTime: 0,
                   epic: "CS.D.USDJPY.TODAY.IP",
                   expiry: "DFB",
                   high: 10567.7,
                   instrumentName: "USD/JPY",
                   instrumentType: "CURRENCIES",
                   lotSize: 1.0,
                   low: 10480.9,
                   marketStatus: "TRADEABLE",
                   netChange: -72.4,
                   offer: 10492.6,
                   percentageChange: -0.69,
                   scalingFactor: 1,
                   streamingPricesAvailable: true,
                   updateTime: "23:52:57",
                   updateTimeUTC: "23:52:57"
                 },
                 position: %Ig.Position{
                   contractSize: 1.0,
                   controlledRisk: false,
                   createdDate: "2020/03/10 23:52:43:000",
                   createdDateUTC: "2020-03-10T23:52:43",
                   currency: "GBP",
                   dealId: "DIAAAADE7NYX6AV",
                   dealReference: "7RVM7N1E33DTCXXZ",
                   direction: "BUY",
                   level: 10491.8,
                   limitLevel: nil,
                   limitedRiskPremium: nil,
                   size: 2.5,
                   stopLevel: nil,
                   trailingStep: nil,
                   trailingStopDistance: nil
                 }
               }
             ]
    end
  end

  test "fetch position by deal id" do
    use_cassette "active_position_by_deal_id" do
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, _} = Ig.User.login(user_pid)
      {:ok, result} = Ig.User.position(user_pid, "DIAAAADE7PDYNAT")

      assert result ==
               %{
                 market: %Ig.Market{
                   bid: 8765.1,
                   delayTime: 0,
                   epic: "CS.D.EURGBP.TODAY.IP",
                   expiry: "DFB",
                   high: 8774.5,
                   instrumentName: "EUR/GBP",
                   instrumentType: "CURRENCIES",
                   lotSize: 1.0,
                   low: 8730.3,
                   marketStatus: "TRADEABLE",
                   netChange: 26.2,
                   offer: 8767.1,
                   percentageChange: 0.3,
                   scalingFactor: 1,
                   streamingPricesAvailable: true,
                   updateTime: "00:09:05",
                   updateTimeUTC: "00:09:05"
                 },
                 position: %Ig.Position{
                   contractSize: 1.0,
                   controlledRisk: false,
                   createdDate: "2020/03/10 23:35:10:000",
                   createdDateUTC: "2020-03-10T23:35:10",
                   currency: "GBP",
                   dealId: "DIAAAADE7PDYNAT",
                   dealReference: "7RVM7N1E33CSPHRN",
                   direction: "BUY",
                   level: 8759.9,
                   limitLevel: 8780.9,
                   limitedRiskPremium: nil,
                   size: 1.0,
                   stopLevel: 8749.9,
                   trailingStep: nil,
                   trailingStopDistance: nil
                 }
               }
    end
  end

  test "returns all top-level nodes in the market navigation hierarchy." do
    use_cassette "market_navigation" do
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, _} = Ig.User.login(user_pid)

      {:ok, result} = Ig.User.market_navigation(user_pid)

      assert %{"markets" => _, "nodes" => [_ | _]} = result
    end
  end

  test "market navigation with node_id" do
    use_cassette "market_navigation_node_id" do
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, _} = Ig.User.login(user_pid)

      node_id = "eur-usd"
      {:ok, result} = Ig.User.market_navigation(user_pid, node_id)

      assert %{"markets" => _, "nodes" => nil} = result
    end
  end

  test "markets" do
    use_cassette "markets" do
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, _} = Ig.User.login(user_pid)

      epics = "ED.D.TL0GY.DAILY.IP"
      {:ok, result} = Ig.User.markets(user_pid, epics)

      assert %{"instrument" => _, "dealingRules" => _, "snapshot" => _} = result
    end
  end

  test "prices" do
    use_cassette "prices" do
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, _} = Ig.User.login(user_pid)

      epics = "ED.D.TL0GY.DAILY.IP"
      {:ok, result} = Ig.User.prices(user_pid, epics)

      assert %{"instrumentType" => _, "metadata" => _, "prices" => [_ | _]} = result
    end
  end

  test "prices with resolution, numPoints" do
    use_cassette "prices_resolution_num_points" do
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, _} = Ig.User.login(user_pid)

      epics = "ED.D.TL0GY.DAILY.IP"
      resolution = "MINUTE"
      num_points = 10

      {:ok, result} = Ig.User.prices(user_pid, epics, resolution, num_points)

      assert %{"instrumentType" => _, "allowance" => _, "prices" => _} = result
    end
  end

  test "prices with resolution, start_date and end_date" do
    use_cassette "prices_resolution_start_date_end_date" do
      {:ok, pid} = Ig.start_link()
      {:ok, user_pid} = Ig.get_user(:user_name, pid)
      {:ok, _} = Ig.User.login(user_pid)

      epics = "ED.D.TL0GY.DAILY.IP"
      resolution = "MINUTE"
      start_date = "2020-01-01 00:00:00"
      end_date = "2020-01-02 00:00:00"
      {:ok, result} = Ig.User.prices(user_pid, epics, resolution, start_date, end_date)

      assert %{"instrumentType" => _, "allowance" => _, "prices" => _} = result
    end
  end
end
