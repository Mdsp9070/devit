defmodule Devit.Core do
  @moduledoc """
  Where the magic happens!
  """

  alias Devit.Config

  import CliSpinners, only: [spin_fun: 2]
  import Devit.Requests
  import Devit.Colors

  @http_error "The HTTP request has failed"
  @invalid_api_key "This API key has errors"
  @missing_api_key "No DEVTO_API_KEY env var was set!"

  def connect(article_path) do
    spin_fun(
      [text: "Attempting to connect to dev.to...", frames: :dots, done: "Connected!"],
      fn -> do_ping_user(article_path) end
    )
  end

  def post({:ok, api_key, article_path}) do
    spin_fun([text: "Posting your article...", frames: :dots, done: "Posted!"], fn ->
      do_post(api_key, article_path)
    end)
  end

  defp do_ping_user(path) do
    Config.api_key()
    |> case do
      {:ok, key} ->
        key
        |> ping_user()
        |> case do
          {:error, :invalid_api_key = err} ->
            desc = @invalid_api_key

            err
            |> error(desc)

            System.halt(1)

          {:error, :request_failed = err} ->
            desc = @http_error

            err
            |> error(desc)

            System.halt(1)

          {:ok, :valid_user} ->
            {:ok, :valid_user}
        end

        {:ok, key, path}

      {:error, :no_api_key = err} ->
        desc = @missing_api_key

        err
        |> error(desc)

        System.halt(1)
    end
  end

  defp do_post(api_key, article_path) do
    article_path
    |> Path.expand()
    |> FrontMatter.parse_file()
    |> case do
      {:ok, matter, body} ->
        request =
          matter
          |> Map.put("body", body)

        api_key
        |> create_article(request)
        |> case do
          {:ok, article_url} ->
            """
            Congrats! Your article has been posted!
            Here's the url: #{article_url}
            """
            |> success()

            {:ok, :posted}

          {:error, :request_failed = err} ->
            desc = @http_error

            err
            |> error(desc)

            System.halt(1)

          {:error, :post_failed = err} ->
            desc = "Error on publishing article"

            err
            |> error(desc)

            System.halt(1)
        end

      {:error, err} ->
        desc = "Failed to parse article"

        err
        |> error(desc)

        System.halt(1)
    end
  end
end
