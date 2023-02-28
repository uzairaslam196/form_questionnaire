defmodule FormQuestionnaireWeb.QuestionnaireLive.Form do
  @moduledoc """
    renders a form quesitonaire
  """
  use FormQuestionnaireWeb, :live_view
  use FormQuestionnaireComponents
  import Ecto.Changeset

  alias FormQuestionnaire.Questionnaire.{Form, Question}
  alias FormQuestionnaire.Questionnaire

  @page_title "Form Questionnaire"

  on_mount({__MODULE__, :metadata})

  def on_mount(:metadata, _params, _, socket) do
    socket
    |> assign(
      meta_tags: %{title: @page_title},
      page_title: @page_title
    )
    |> then(&{:cont, &1})
  end

  def mount(_, _, socket) do
    socket
    |> assign(:changeset, Form.changeset(%Form{}))
    |> then(&{:ok, &1})
  end

  def render(assigns) do
    ~H"""
    <.app>
      <:title><%= @page_title %></:title>

      <div class="p-10 bg-white rounded-md shadow-md w-1/2 mx-auto my-10">
        <.form
          :let={f}
          for={@changeset}
          as={:form_questionnaire}
          phx-submit="create_crew_change"
          phx-change="change"
          class="p-6 flex flex-col gap-y-4"
          id={"questionnaire-form"}
        >
          <.text_input form={f} field={:name} label="Form Name"/>
          <.text_input form={f} field={:description} label="Form Description"/>

          <%= if Enum.any?(inputs_for(f, :questions)) do %>
            <div class="text-xl font-bold">Questions:</div>
          <% end %>

          <%= inputs_for f, :questions, fn q -> %>
            <.text_input form={q} field={:title} label="Title"/>
            <div class="flex gap-6">
              <.radio_button form={q} field={:question_type} label="Text" value="text" checked={q.params["question_type"] == "text"} />
              <.radio_button form={q} field={:question_type} label="MCQS" value="mcqs" checked={q.params["question_type"] == "mcqs"} />
            </div>

            <div class="w-48 ml-6">
              <%= inputs_for q, :options, fn o -> %>
                <.text_input form={o} field={:name} label={"Option #{o.index + 1}"} />
              <% end %>
              </div>
          <% end %>
        </.form>

        <button
          class="bg-transparent text-blue-500 py-2 px-4 mx-6 border border-blue-500 rounded ml-4 cursor-pointer mx-6"
          phx-click="add-question"
          id="add-form"
        >
          Add Question
        </button>

        <%= submit("Save",
          class: "btn text-blue-500 block border border-blue-500 rounded px-5 py-2 text-base mx-auto",
          form: "questionnaire-form"
        ) %>
      </div>
    </.app>
    """
  end

  defp radio_button(assigns) do
    assigns = Enum.into(assigns, %{checked: false, label: nil})

    ~H"""
    <div class="flex gap-2">
      <%= @label %>
      <%= radio_button(@form, @field, @value, checked: @checked, class: "mt-1") %>
    </div>
    """
  end

  def handle_event("add-question", %{}, %{assigns: %{changeset: changeset}} = socket) do
    q_changeset = Question.changeset(%Question{}, %{question_type: "text"})
    q_changesets = Map.get(changeset.changes, :questions, []) ++ [q_changeset]

    socket
    |> assign(:changeset, change(changeset, %{questions: q_changesets}))
    |> then(&{:noreply, &1})
  end


  def handle_event(
    "change",
    %{
      "_target" => ["form_questionnaire", "questions", num, "question_type"],
     "form_questionnaire" => form_questionnaire},
      socket) do

    form_questionnaire
    |> get_in(["questions", num, "question_type"])
    |> case do
      "mcqs" ->
        [%{}, %{}, %{}, %{}]
      _ ->
        []
    end
    |> then(& put_in(form_questionnaire, ["questions", num, "options"], &1))
    |> then(& assign(socket, :changeset, Form.changeset(%Form{}, &1)))
    |> then(&{:noreply, &1})
  end

  def handle_event(
    "change",
    %{
     "form_questionnaire" => form_questionnaire},
     socket)
     do
    socket
    |> assign(:changeset, Form.changeset(%Form{}, form_questionnaire))
    |> then(&{:noreply, &1})
  end

  def handle_event(
    "create_crew_change",
    %{"form_questionnaire" => form_questionnaire},
     socket
     ) do

    case Form.changeset(%Form{}, form_questionnaire) do
      %{valid?: true} ->
        {:ok, %{id: id}} = Questionnaire.create_from(form_questionnaire)
        socket
        |> push_navigate(to: Routes.questionnaire_preview_form_path(socket, :index, id))
        |> then(&{:noreply, &1})
      %{valid?: false} = changeset ->
        socket
        |> assign(:changeset, changeset)
        |> then(&{:noreply, &1})
    end
  end
end
