defmodule FormQuestionnaire.Questionnaire.Question do
  @moduledoc """
  Form template for form-state stages
  """
  use FormQuestionnaire.Schema
  import Ecto.Changeset
  alias FormQuestionnaire.Questionnaire.{Form, Option}

  schema "questions" do
    field(:question_type, :string)
    field(:title, :string)
    field(:add_row, :boolean, virtual: true, default: false)
    embeds_many(:options, Option, on_replace: :delete)
    belongs_to(:form, Form)
    timestamps()
  end

  def new(params \\ %{}) do
    params
    |> (&struct(__MODULE__, &1)).()
  end

  def changeset(%__MODULE__{} = form, params \\ %{}) do
    form
    |> cast(params, [:title, :question_type, :form_id])
    |> validate_required([:title, :question_type])
    |> cast_embed(:options, with: &Option.changeset/2)
  end
end
