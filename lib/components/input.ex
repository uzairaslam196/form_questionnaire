defmodule FormQuestionnaireComponents.Input do
  @moduledoc false
  use Phoenix.Component
  import Phoenix.HTML.Form
  import FormQuestionnaireComponents.Helpers

  @rest_exclusions ~w(readonly disabled class input_opts phx-hook inline_label)a
  @input_opts_exclusions ~w(form field label size feedback input_opts helper_message container_class validate_success inline_label)a

  def text_input(assigns) do
    assigns

    |> assign_defaults()
    |> assign_input_opts()
    |> assign_rest(@rest_exclusions)
    |> render_text_input()
  end

  defp render_text_input(assigns) do
    ~H"""
    <.input_container {@rest}>
      <%= text_input(
        @form,
        @field,
        Keyword.merge(@input_opts, class: input_class(@form, @field, @size, @rest))
      ) %>
    </.input_container>
    """
  end



  def hidden_input(assigns) do
    assigns =
      assigns
      |> assign_defaults()
      |> assign_input_opts()

    ~H"""
    <%= hidden_input(@form, @field, @input_opts) %>
    """
  end

  def render_checkbox_input(assigns) do
    ~H"""
    <.input_container {@rest} class="flex items-center gap-x-2">
      <%= checkbox(
        @form,
        @field,
        Keyword.merge(@input_opts,
          class:
            "w-4 h-4 text-blue-600 bg-gray-100 rounded border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
        )
      ) %>
      <%= for label <- @inline_label do %>
        <label class={[label_class(@form, @field, @rest), "mb-0"]} for={@id}>
          <%= render_slot(label) %>
        </label>
      <% end %>
    </.input_container>
    """
  end

  def input_container(assigns) do
    assigns
    |> assign_new(:helper_message, fn -> [] end)
    |> assign_new(:container_class, fn -> nil end)
    |> assign_rest(
      ~w(id form field feedback label helper_message ignore_update container_class required)a
    )
    |> render_input_container()
  end

  defp render_input_container(assigns) do
    ~H"""
    <div id={"#{@id}-container"} {@rest} class={@container_class}>
      <%= case @label do %>
        <% label when is_binary(label) -> %>
          <%= label(@form, @field, label, class: label_class(@form, @field, @rest), for: @id) %>
          <.required_marker :if={input_required?(assigns)} />
        <% nil when not is_nil(@field) -> %>
          <%= label(@form, @field, class: label_class(@form, @field, @rest), for: @id) %>
          <.required_marker :if={input_required?(assigns)} />
        <% _ -> %>
      <% end %>
      <%= render_slot(@inner_block) %>
      <.error_tag form={@form} field={@field} feedback={@feedback} />
    </div>
    """
  end

  defp assign_defaults(assigns) do
    assigns
    |> assign_new(:form, fn -> nil end)
    |> assign_new(:field, fn -> nil end)
    |> assign_new(:label, fn -> nil end)
    |> assign_new(:size, fn -> :default end)
    |> assign_new(:feedback, fn -> false end)
    |> assign_new(:validate_success, fn -> true end)
    |> assign_new(:id, fn -> id(assigns[:form], assigns[:field]) end)
  end

  defp id(nil, nil), do: "default-input"
  defp id(form, field), do: input_id(form, field)

  defp changed?(%{source: %{changes: changes, action: action}})
       when action in [:insert, :update] do
    changes !== %{}
  end

  defp changed?(_), do: false

  defp input_class(nil, _field, size, _opts) do
    [
      "focus:ring-blue-500 focus:border-blue-500 bg-gray-50 border border-gray-300 text-gray-900 rounded-lg block w-full p-2.5",
      text_size_class(size),
    ]
    |> build_class()
  end

  defp input_class(form, field, size, opts) do
    [
      "bg-gray-50 border border-gray-300 text-gray-900 rounded-lg block w-full p-2.5",
      text_size_class(size),
      cond do
        opts[:validate_success] and valid?(form, field) and changed?(form) ->
          "bg-green-50 border-green-500 text-green-900 placeholder-green-700 focus:ring-green-500 focus:border-green-500 dark:bg-gray-700 dark:text-green-500 dark:placeholder-green-500"

        !opts[:validate_success] or valid?(form, field) ->
          ""

        true ->
          "bg-red-50 border-red-500 text-red-900 placeholder-red-700 focus:ring-red-500 focus:border-red-500 dark:bg-gray-700 dark:text-red-500 dark:placeholder-red-500"
      end
    ]
    |> build_class()
  end

  defp label_class(nil, _field, _opts), do: "inline-block mb-2 text-sm font-medium text-gray-900"

  defp label_class(form, field, opts) do
    build_class([
      "inline-block mb-2 text-sm font-medium text-gray-900",
      cond do
        opts[:validate_success] and valid?(form, field) and changed?(form) ->
          "text-green-700 dark:text-green-500 success-label"

        !opts[:validate_success] or valid?(form, field) ->
          ""

        true ->
          "text-red-700 dark:text-red-500 error-label"
      end
    ])
  end

  defp error_tag(%{form: form, field: field} = assigns) when is_nil(form) or is_nil(field),
    do: ~H""

  defp error_tag(assigns) do
    assigns =
      assigns
      |> then(fn %{form: form, field: field} = assigns ->
        if assigns.feedback do
          assigns
          |> Map.put(:phx_feedback_for, input_name(form, field))
        else
          assigns
        end
      end)
      |> assign_rest(~w(form field feedback)a)

    ~H"""
    <%= for error <- Keyword.get_values(@form.errors, @field) do %>
      <p
        id={input_id(@form, @field, "error")}
        class="mt-2 text-sm text-red-600 dark:text-red-500 invalid-feedback"
        {@rest}
      >
        <%= translate_error(error) %>
      </p>
    <% end %>
    """
  end

  defp text_size_class(size) do
    case size do
      :large -> "sm:text-md"
      :small -> "sm:text-xs"
      _ -> "text-sm"
    end
  end

  defp required_marker(assigns), do: ~H(<span class="text-red-600 dark:text-red-500">*</span>)

  defp input_required?(assigns) do
    case assigns do
      %{required: required} ->
        required

      %{form: %_{} = form, field: field} when not is_nil(field) ->
        form |> input_validations(field) |> Keyword.get(:required, false)

      _ ->
        false
    end
  end

  defp assign_input_opts(assigns, exclude \\ @input_opts_exclusions) do
    assigns
    |> assign(:input_opts, assigns_to_attributes(assigns, exclude))
    |> update(:input_opts, fn opts -> Keyword.put(opts, :id, assigns.id) end)
  end

  defp valid?(nil, _field), do: true

  defp valid?(form, field) do
    is_nil(form.errors[field])
  end

  defp translate_error({msg, _opts}) do
    msg
  end
end
