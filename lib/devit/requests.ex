defmodule Devit.Requests do
  @moduledoc """
  Module to interact with the Dev.to API
  """

  @user "/api/users/me"
  @article "/api/articles"

  def pings_user(api_key) do
    api_key
    |> build_client()
    |> Tesla.get(@user)
    |> case do
      {:ok, %{body: body}} ->
        if !is_integer(body["id"]) do
          {:error, :invalid_api_key}
        else
          {:ok, :valid_user}
        end

      {:error, _error} ->
        {:error, :request_failed}
    end
  end

  def create_article(api_key, data) do
    body =
      ~s("title": "#{data[:title]}", "body_markdown": "#{data[:markdown]}", "published": #{
        data[:published]
      }, "tags": #{data[:tags]})

    api_key
    |> build_client()
    |> Tesla.post(@article, body: body)
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
