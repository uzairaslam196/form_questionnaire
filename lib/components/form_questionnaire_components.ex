defmodule FormQuestionnaireComponents do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      import FormQuestionnaireComponents.{
        Input,
        Layout,
        Navbar
      }
    end
  end
end
