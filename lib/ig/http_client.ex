defmodule Ig.HTTPClient do
  @live_endpoint "https://api.ig.com/gateway/deal"
  @demo_endpoint "https://demo-api.ig.com/gateway/deal"

  def post(is_demo, uri, body, headers \\ []) do
    make_request(:post, is_demo, uri, body, headers)
  end

  def get(is_demo, uri, headers \\ []) do
    make_request(:get, is_demo, uri, "", headers)
  end

  defp make_request(method, is_demo, uri, body, headers) do
    complete_headers = default_headers() ++ headers
    full_url = "#{base_url(is_demo)}#{uri}"

    body_string =
      if method == :get do
        ""
      else
        Jason.encode!(body)
      end

    HTTPoison.request(method, full_url, body_string, complete_headers)
  end

  defp base_url(true), do: @demo_endpoint
  defp base_url(_), do: @live_endpoint

  defp default_headers() do
    [
      {"Content-Type", "application/json; charset=UTF-8"},
      {"Accept", "application/json; charset=UTF-8"}
    ]
  end
end
