defmodule FormQuestionnaire.Repo.Migrations.CreateForms do
  use Ecto.Migration

  def change do
    create table(:forms, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string, null: false)
      add(:description, :string)
      timestamps()
    end
  end
end
