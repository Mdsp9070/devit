defmodule Devit.Colors do
  @moduledoc """
  Here I define some helper functions to colorize output
  """

  alias IO.ANSI

  @success "✅"
  @failure "❎"
  @warning "⚠️"

  def build_error(msg) do
    "#{@failure} #{msg}"
    |> red()
  end

  def build_error(err, desc) do
    "#{@failure} #{err}: #{desc}"
    |> red()
  end

  def error(msg) do
    msg
    |> build_error()
    |> IO.puts()
  end

  def error(err, desc) do
    err
    |> build_error(desc)
    |> IO.puts()
  end

  def build_success(desc) do
    "#{@success} #{desc}"
    |> green()
  end

  def success(desc) do
    desc
    |> build_success()
    |> IO.puts()
  end

  def build_warning(name, desc) do
    "#{@warning} #{name}: #{desc}"
    |> yellow()
    |> IO.puts()
  end

  def warning(name, desc) do
    name
    |> build_warning(desc)
    |> IO.puts()
  end

  def build_info(text) do
    "#{text}"
    |> blue()
  end

  def build_info(name, desc) do
    "#{name}: #{desc}"
    |> blue()
  end

  def info(text) do
    text
    |> build_info()
    |> IO.puts()
  end

  def info(name, desc) do
    name
    |> build_info(desc)
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

  def blue(text) do
    ANSI.blue() <> text <> ANSI.reset()
  end
end
