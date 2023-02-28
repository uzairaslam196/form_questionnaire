defmodule FormQuestionnaire.Questionnaire.Option do
  @moduledoc """
  Option
  """
  use FormQuestionnaire.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:delete, :boolean, virtual: true, default: false)
    field(:name, :string)
  end

  def changeset(%__MODULE__{} = option, attrs \\ %{}) do
    option
    |> cast(attrs, [:id, :name, :delete])
    |> validate_required([:name])
  end
end
