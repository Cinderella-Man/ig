defmodule Ig.RestClient do
  @live_endpoint "https://api.ig.com/gateway/deal"
  @demo_endpoint "https://demo-api.ig.com/gateway/deal"

  def login(is_demo, identifier, password, api_key) do
    {:ok, %HTTPoison.Response{} = response} =
      post(is_demo, '/session', %{identifier: identifier, password: password}, [
        {"X-IG-API-KEY", api_key},
        {"VERSION", 2}
      ])

    case response do
      %{status_code: 200} ->
        response_body = Jason.decode!(response.body)
        cst = Enum.find(response.headers, {nil, nil}, &(elem(&1, 0) == "CST")) |> elem(1)

        security_token =
          Enum.find(response.headers, {nil, nil}, &(elem(&1, 0) == "X-SECURITY-TOKEN")) |> elem(1)

        {:ok,
         Map.merge(response_body, %{
           :cst => cst,
           :security_token => security_token,
           :api_key => api_key
         })}

      _ ->
        handle_error(response)
    end
  end

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

  defp handle_error(%{body: body}) do
    response_body = Jason.decode!(body)
    {:error, response_body}
  end
end
