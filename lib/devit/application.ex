defmodule Devit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Devit.Client, only: [child_spec: 0]

  @impl true
  def start(_type, _args) do
    children = [
      {Finch, child_spec()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Devit.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
