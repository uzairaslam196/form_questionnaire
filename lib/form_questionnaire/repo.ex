defmodule FormQuestionnaire.Repo do
  use Ecto.Repo,
    otp_app: :form_questionnaire,
    adapter: Ecto.Adapters.Postgres
end
