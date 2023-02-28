defmodule FormQuestionnaire.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:title, :string)
      add(:options, {:array, :map}, default: [])
      add(:question_type, :string)
      add(:form_id, references(:forms, on_delete: :delete_all, type: :binary_id))
      timestamps()
    end
  end
end
