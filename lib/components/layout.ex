defmodule FormQuestionnaireComponents.Layout do
  @moduledoc """
  Reusable layouts within the application
  """
  use Phoenix.Component

  attr(:class, :string, default: "")
  attr(:rest, :global)

  slot(:breadcrumbs,
    doc: "Slot for breadcrumbs. Use Martide.Components.breadcrumbs/1 inside of it"
  )

  slot(:title, doc: "Title of the page")

  slot(:buttons,
    doc: """
    Button/any element or series of buttons/any elements located at the far-right of the title.
    Usually this is where add/filter buttons are located
    """
  )

  slot(:inner_block, required: true)

  @doc """
  The main app layout. This layout's min height is fixed to 100vh minus the topbar height which is 4rem.
  This layout is mainly used as a container of LiveView pages.
  """
  def app(assigns) do
    ~H"""
    <div class={["flex flex-col min-h-[calc(100vh-4rem)]", @class]} {@rest}>
      <div class="bg-white dark:bg-gray-900 border-b border-gray-200">
        <div class="px-2 pt-2.5 sm:px-4 sm:pt-4">
          <%= render_slot(@breadcrumbs) %>
        </div>

        <div class="flex justify-between items-center px-2 py-2.5 sm:pl-4 sm:pr-8 sm:py-5">
          <div class="font-semibold text-gray-900 text-2xl">
            <%= render_slot(@title) %>
          </div>

          <div class="flex items-center space-x-2.5">
            <%= render_slot(@buttons) %>
          </div>
        </div>
      </div>

      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
