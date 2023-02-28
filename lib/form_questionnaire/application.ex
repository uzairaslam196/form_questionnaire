defmodule FormQuestionnaire.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      FormQuestionnaire.Repo,
      # Start the Telemetry supervisor
      FormQuestionnaireWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: FormQuestionnaire.PubSub},
      # Start the Endpoint (http/https)
      FormQuestionnaireWeb.Endpoint
      # Start a worker by calling: FormQuestionnaire.Worker.start_link(arg)
      # {FormQuestionnaire.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FormQuestionnaire.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FormQuestionnaireWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
