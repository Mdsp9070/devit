defmodule Devit.Config do
  @moduledoc """
  Retrive system configs
  """

  def api_key do
    case System.get_env("DEVTO_API_KEY") do
      key when is_binary(key) ->
        {:ok, key}

      nil ->
        {:error, :no_api_key}
    end
  end
end
