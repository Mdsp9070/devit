defmodule Devit.Erros do
  @moduledoc """
  Define common application errors messages
  """

  def http_error, do: "The HTTP request has failed"
  def invalid_api_key, do: "This API key has errors"
  def missing_api_key, do: "No DEVTO_API_KEY env var was set!"
end
