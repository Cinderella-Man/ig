defmodule Ig.HTTPClient do
  @live_endpoint "https://api.ig.com/gateway/deal"
  @demo_endpoint "https://demo-api.ig.com/gateway/deal"

  def post(is_demo, uri, body, headers \\ []) do
    base_url = base_url(is_demo)
    body_string = Jason.encode!(body)

    complete_headers = [
      {"Content-Type", "application/json; charset=UTF-8"},
      {"Accept", "application/json; charset=UTF-8"},
      {"VERSION", 2} | headers
    ]

    HTTPoison.post("https://demo-api.ig.com/gateway/deal#{uri}", body_string, complete_headers)
  end

  defp base_url(true), do: @demo_endpoint
  defp base_url(_), do: @live_endpoint
end
