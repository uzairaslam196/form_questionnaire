defmodule FormQuestionnaireComponents.Helpers do
  alias Phoenix.Component
  alias String.Chars

  use Phoenix.Component

  def build_class(list, joiner \\ " ")
  def build_class([], _joiner), do: ""

  def build_class(list, joiner) when is_list(list) do
    list
    |> join_non_empty_list(joiner, [])
    |> :lists.reverse()
    |> IO.iodata_to_binary()
  end

  # Remove joiner (if present), since our last element was empty and isn't added
  defp join_non_empty_list([""], joiner, [joiner | acc]), do: acc
  defp join_non_empty_list([nil], joiner, [joiner | acc]), do: acc
  defp join_non_empty_list([""], _joiner, acc), do: acc
  defp join_non_empty_list([nil], _joiner, acc), do: acc
  defp join_non_empty_list([first], _joiner, acc), do: [entry_to_string(first) | acc]

  # Don't append empty string to our class list
  defp join_non_empty_list(["" | rest], joiner, acc) do
    join_non_empty_list(rest, joiner, acc)
  end

  defp join_non_empty_list([nil | rest], joiner, acc) do
    join_non_empty_list(rest, joiner, acc)
  end

  defp join_non_empty_list([first | rest], joiner, acc) do
    join_non_empty_list(rest, joiner, [joiner, entry_to_string(first) | acc])
  end

  # Trim the input string
  def entry_to_string(entry) when is_binary(entry), do: String.trim(entry)
  def entry_to_string(entry), do: String.trim(Chars.to_string(entry))

  def assign_rest(assigns, exclude) do
    Component.assign(
      assigns,
      :rest,
      Component.assigns_to_attributes(assigns, exclude)
    )
  end

  def button(assigns) do
   assigns =  Enum.into(assigns, %{
     event: nil,
     id: "add-form",
     class: "btn text-blue-500 block border border-blue-500 rounded px-5 py-2 text-base mx-auto",
     second_class: ""
     })

    ~H"""
    <button
      class={@class <> " " <> @second_class}
      phx-click={@event}
      id="add-form"
    >
    <%= @title %>
    </button>
    """
  end
end
