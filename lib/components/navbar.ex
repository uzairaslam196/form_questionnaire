defmodule FormQuestionnaireComponents.Navbar do
  use Phoenix.Component
  import FormQuestionnaireComponents.Helpers

  def navbar(assigns) do
    assigns =
      assigns
      |> assign_new(:sticky, fn -> false end)
      |> assign_new(:left, fn -> [] end)
      |> assign_new(:middle, fn -> [] end)
      |> assign_new(:right, fn -> [] end)
      |> assign_new(:class, fn ->
        "bg-white border-gray-200 px-4 py-2.5 rounded dark:bg-gray-900"
      end)
      |> assign_new(:container_class, fn ->
        "max-w-screen-xl flex flex-wrap justify-between items-center mx-auto"
      end)

    ~H"""
    <nav class={build_class([@class, get_sticky_classes(@sticky)])}>
      <div class={@container_class}>
        <%= render_slot(@left) %>
        <%= render_slot(@middle) %>
        <%= render_slot(@right) %>
      </div>
    </nav>
    """
  end

  def logo(assigns) do
    assigns =
      assigns
      |> assign_new(:site_name, fn -> "" end)
      |> assign_new(:logo, fn -> "https://static.martide.com/images/martide-logo-blue.png" end)
      |> assign_new(:class, fn -> "" end)

    ~H"""
    <a href={"#"} class={build_class(["flex items-center", @class])}>
      <img src={@logo} class="mr-3 h-6 sm:h-9" alt="Martide Logo" />

      <%= if @site_name do %>
        <span class="self-center text-xl font-semibold whitespace-nowrap"><%= @site_name %></span>
      <% end %>
    </a>
    """
  end

  defp get_sticky_classes(true),
    do: "fixed w-full z-20 top-0 left-0 border-b border-gray-200 dark:border-gray-600"

  defp get_sticky_classes(_), do: ""
end
