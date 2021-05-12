defmodule Devit.Colors do
  @moduledoc """
  Here I define some helper functions to colorize output
  """

  alias IO.ANSI

  @success "✅"
  @failure "❎"
  @warning "⚠️"

  def error(err, desc) do
    "#{@failure} #{err}: #{desc}"
    |> red()
    |> IO.puts()
  end

  def success(desc) do
    "#{@success} #{desc}"
    |> green()
    |> IO.puts()
  end

  def warning(name, desc) do
    "#{@warning} #{name}: #{desc}"
    |> yellow()
    |> IO.puts()
  end

  def green(text) do
    ANSI.green() <> text <> ANSI.reset()
  end

  def red(text) do
    ANSI.red() <> text <> ANSI.reset()
  end

  def yellow(text) do
    ANSI.yellow() <> text <> ANSI.reset()
  end
end
