defmodule Ig.HTTPClient do
  @live_endpoint "https://api.ig.com/gateway/deal"
  @demo_endpoint "https://demo-api.ig.com/gateway/deal"

  def post(url, body, headers \\ []) do
    HTTPoison.post("#{@endpoint}#{url}", headers)
  end
end
