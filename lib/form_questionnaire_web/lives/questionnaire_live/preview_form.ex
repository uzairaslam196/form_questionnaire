defmodule FormQuestionnaireWeb.QuestionnaireLive.PreviewForm do
  @moduledoc """
    preview a form quesitonaire
  """
  use FormQuestionnaireWeb, :live_view
  use FormQuestionnaireComponents
  alias FormQuestionnaire.Questionnaire

  @page_title "Form Questionnaire"

  def mount(%{"form_id" => id}, _, socket) do
    socket
    |> assign(page_title: @page_title)
    |> assign(:form, Questionnaire.get!(id))
    |> then(&{:ok, &1})
  end

  def render(assigns) do
    ~H"""
    <.app>
      <:title><%= @page_title %></:title>

      <div class="p-10 bg-white rounded-md shadow-md w-1/2 mx-auto my-10">
        Your Form Has Been Successfully Saved. Would you like to share?

        <div class="flex flex-col mt-8">
          <h1 class="text-2xl w-fit mx-auto"><%= @form.name %></h1>
          <p class="text-lg w-fit mx-auto"><%= @form.description %></p>
        </div>

        <h2 class="font-bold mt-8">Questions:</h2>

        <div class="flex flex-col gap-6 mt-4 pb-8 border-b-2">
          <%= for {%{title: title} = question, i}  <- @form.questions |> Enum.with_index(1) do %>
            <div>
              <h4 class="font-semibold"><%= i %> - <%= title %></h4>
              <.answer_fields question={question} />
            </div>
          <% end %>
        </div>

        <.button event="share" title="Share with Users" second_class="mt-8" />
      </div>
    </.app>
    """
  end

  defp answer_fields(%{question: %{question_type: "mcqs"}} = assigns) do
    ~H"""
      <div class="ml-2">
      <%= for option <- @question.options  do %>
        <div>
          <%= checkbox(:form, :mcq_option) %>
          <span class="ml-2"><%= option.name %></span>
        </div>
      <% end %>
      </div>
    """
  end

  defp answer_fields(%{question: %{question_type: "text"}} = assigns) do
    ~H"""
      <div class="ml-2 mt-4">
        <%= textarea(:form, :title, class: "w-full") %>
      </div>
    """
  end
end
