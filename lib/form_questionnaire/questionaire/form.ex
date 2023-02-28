defmodule FormQuestionnaire.Questionnaire.Form do
  @moduledoc """
  Form template for form-state stages
  """
  use FormQuestionnaire.Schema
  import Ecto.Changeset

  alias FormQuestionnaire.Questionnaire.Question

  schema "forms" do
    field(:name, :string)
    field(:description, :string)
    field(:add_question, :boolean, virtual: true, default: false)
    has_many(:questions, Question, on_replace: :delete)
    timestamps()
  end

  def new(params \\ %{}) do
    params
    |> (&struct(__MODULE__, &1)).()
  end

  def changeset(form, params \\ %{}) do
    form
    |> cast(params, [:name, :description])
    |> cast_assoc(:questions, with: &Question.changeset/2)
    |> validate_required([:name])
  end
end
