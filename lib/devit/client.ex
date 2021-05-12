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

  @spec create_article(String.t(), String.t()) ::
          {:ok, String.t()} | {:error, atom() | String.t()}
  def create_article(api_key, body) do
    headers = [{"content-type", "application/json"} | base_headers(api_key)]

    :post
    |> Finch.build(article_url(), headers, body)
    |> Finch.request(__MODULE__)
    |> handle_articles_response()
  end

  defp handle_articles_response({:ok, %Response{status: 201, body: body}}) do
    article_url =
      body
      |> Jason.decode!()
      |> Map.get("url")

    {:ok, article_url}
  end

  defp handle_articles_response({:ok, %Response{status: 422, body: body}}) do
    reason =
      body
      |> Jason.decode!()
      |> Map.get("error")

    {:error, reason}
  end

  defp handle_articles_response({:error, _reason} = err), do: err
  defp handle_articles_response({:ok, %Response{status: 400}}), do: {:error, :bad_request}
  defp handle_articles_response({:ok, %Response{status: 401}}), do: {:error, :unauthorized}
  defp handle_articles_response({:ok, %Response{status: 403}}), do: {:error, :forbidden}
  defp handle_articles_response({:ok, %Response{status: 429}}), do: {:error, :many_requests}

  @spec ping_user(String.t()) :: {:ok, :valid_user} | {:error, atom()}
  def ping_user(api_key) do
    :get
    |> Finch.build(user_url(), base_headers(api_key))
    |> Finch.request(__MODULE__)
    |> handle_user_response()
  end

  defp handle_user_response({:error, _reason} = err), do: err
  defp handle_user_response({:ok, %Response{status: 200}}), do: {:ok, :valid_user}
  defp handle_user_response({:ok, %Response{status: 401}}), do: {:error, :unauthenticated}
  defp handle_user_response({:ok, %Response{status: _}}), do: {:error, :invalid_api_key}

  defp pool_size, do: 2

  defp base_url, do: "https://dev.to/api"
  defp user_url, do: base_url() <> "/users/me"
  defp article_url, do: base_url() <> "/articles"
  defp base_headers(api_key), do: [{"api_key", api_key}]
end
