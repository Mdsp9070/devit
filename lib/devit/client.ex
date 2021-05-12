defmodule Devit.Client do
  @moduledoc """
  HTTP client to interact with dev.to API
  """

  alias Finch.Response

  def child_spec do
    [
      name: __MODULE__,
      pools: %{
        "https://dev.to" => [size: pool_size()]
      }
    ]
  end

  @spec ping_user(String.t()) :: {:ok, :valid_user} | {:error, atom()}
  def ping_user(api_key) do
    :get
    |> Finch.build(user_url(), headers(api_key))
    |> Finch.request(__MODULE__)
    |> handle_user_response()
  end

  defp handle_user_response({:ok, %Response{status: 200}}), do: {:ok, :valid_user}
  defp handle_user_response({:ok, %Response{status: 401}}), do: {:error, :unauthenticated}
  defp handle_user_response({:ok, %Response{status: _}}), do: {:error, :invalid_api_key}
  defp handle_user_response({:error, _reason} = err), do: err

  defp pool_size, do: 2

  defp base_url, do: "https://dev.to/api"
  defp user_url, do: base_url() <> "/users/me"
  defp article_url, do: base_url() <> "/articles"
  defp headers(api_key), do: [{"api_key", api_key}]
end
