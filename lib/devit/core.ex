defmodule Devit.Core do
  @moduledoc """
  Where the magic happens!
  """

  alias Devit.{Client, Colors, Config}

  import CliSpinners, only: [spin_fun: 2]

  def run(article_path) do
    validate_user()

    article_path
    |> parse_article()
    |> build_article_body()
    |> post_article()
  end

  defp validate_user do
    init_text = "Validating your user into dev.to...\n" |> Colors.build_info()
    done_text = "Congrats, you're a valid dev.to user!" |> Colors.build_success()

    spin_fun(
      spin_opts(init_text, done_text),
      fn ->
        Config.get_api_key() |> handle_api_key() |> Client.ping_user() |> handle_user_result()
      end
    )
  end

  defp post_article(body) do
    init_text = "Trying to publish your article... Gimme a sec!\n" |> Colors.build_info()
    done_text = "\n"

    spin_fun(
      spin_opts(init_text, done_text),
      fn ->
        Config.get_api_key()
        |> handle_api_key()
        |> Client.create_article(body)
        |> handle_article_result()
      end
    )
  end

  defp parse_article(path) do
    path
    |> Path.expand()
    |> FrontMatter.parse_file()
    |> case do
      {:ok, matter, body} ->
        {matter, body}

      {:error, err} ->
        desc = "Failed to parse article"

        err
        |> Colors.error(desc)

        System.halt(1)
    end
  end

  defp build_article_body({matter, body}) do
    """
    {
      "article": {
        "body_markdown": #{body},
        "tags": #{matter["tags"]},
        "title": #{matter["title"]},
        "series": #{matter["series"]},
        "published": #{matter["published"]},
        "main_image": #{matter["cover_image"]}
      }
    }
    """
  end

  defp handle_article_result({:ok, article_url}) do
    """
    Congrats! Your article has been posted!
    Here's the url: #{article_url}
    """
    |> Colors.success()
  end

  defp handle_article_result({:error, reason}) do
    reason_text =
      case reason do
        %{reason: mint_error} -> "Request failed with #{mint_error} failure!"
        _ -> "The root of evilness was: #{inspect(reason)}"
      end

    "Article creation failed"
    |> Colors.error(reason_text)

    System.halt(1)
  end

  defp handle_user_result({:ok, :valid_user} = ok), do: ok

  defp handle_user_result({:error, reason}) do
    reason_text =
      case reason do
        :unauthorized -> "Your login has failed! Maybe is an internal error :/"
        :invalid_api_key -> "Your API key is invalid, please, double check it!"
        %{reason: mint_error} -> "Request failed with #{mint_error} failure!"
      end

    "User validation failed"
    |> Colors.error(reason_text)

    System.halt(1)
  end

  defp handle_api_key({:ok, key}), do: key

  defp handle_api_key({:error, :no_api_key}) do
    reason = "You didn't set `DEVTO_API_KEY` env var!"

    "Impossible to proceed"
    |> Colors.error(reason)

    System.halt(1)
  end

  defp spin_opts(text, done_text) do
    [
      text: text,
      done: done_text,
      frames: frames(),
      interval: interval()
    ]
  end

  defp frames, do: :dots
  defp interval, do: 1000
end
