defmodule Devit.Requests do
  @moduledoc """
  Module to interact with the Dev.to API
  """

  @user "/api/users/me"
  @article "/api/articles"

  def ping_user(api_key) do
    api_key
    |> build_client()
    |> Tesla.get(@user)
    |> case do
      {:ok, %{body: body}} ->
        if is_integer(body["id"]) do
          {:ok, :valid_user}
        else
          {:error, :invalid_api_key}
        end

      {:error, _error} ->
        {:error, :request_failed}
    end
  end

  def create_article(api_key, data) do
    body = %{
      "article" => %{
        "tags" => data["tags"],
        "title" => data["title"],
        "published" => data["published"],
        "body_markdown" => data["body"]
      }
    }

    api_key
    |> build_client()
    |> Tesla.post(@article, body)
    |> case do
      {:ok, %{status: status, body: body}} ->
        if status == 201 do
          {:ok, body["url"]}
        else
          {:error, :post_failed}
        end

      {:error, _error} ->
        {:error, :request_failed}
    end
  end

  defp build_client(api_key) do
    middlewares = [
      {Tesla.Middleware.BaseUrl, "https://dev.to"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"api_key", api_key}]}
    ]

    Tesla.client(middlewares)
  end
end
