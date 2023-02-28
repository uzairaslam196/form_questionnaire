defmodule FormQuestionnaire.Questionnaire do
  alias FormQuestionnaire.Questionnaire.Form
  alias FormQuestionnaire.Repo
  import Ecto.Query

  def create_from(attrs) do
    %Form{}
    |> Form.changeset(attrs)
    |> Repo.insert()
  end

  def get!(id) do
    Form
    |> where(id: ^id)
    |> preload([:questions])
    |> Repo.one!()
  end
end
