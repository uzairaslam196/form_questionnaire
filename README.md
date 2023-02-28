# FormQuestionnaire

This is a dynamic nested form built using Phoenix Elixir that allows users to create forms with multiple questions and options.
Getting Started

To get started with this project, follow these steps:

    Install the necessary dependencies with mix deps.get.
    Install assets cd /assets && npm install
    Set up the database with mix ecto.setup.
    Start the server with mix phx.server.
    Open your browser and navigate to localhost:4000.

Usage

To use the Form Questionnaire application, follow these steps:

    Create a new form with a name and a description.
    Add questions to the form, with a text prompt and a type (multiple choice or checkboxes or paragraph).
    Add options to each question for multiple choice or checkboxes type.
    Preview the form to see all questions and options.
    Share the form with users to receive their answers.

Tables

The following tables are used in the Form Questionnaire application:

    form: Contains information about the form, including the name and description.
    questions: Contains information about each question, including the text prompt, type, and form_id.
    options: Contains information about each option for multiple choice or checkboxes questions, including the text of the option and the ID of the question it belongs to.

Live Component

The FormLive component is responsible for adding questions to the form dynamically. This component allows users to add, edit, and delete questions without refreshing the page.
Evaluation Criteria

This project will be evaluated based on the following criteria:

    Functionality: Does the form meet all the requirements?
    Code quality: Is the code well-organized, well-documented, and maintainable?
    Test coverage: Are there tests for all the functionality?
    User interface: Is the frontend easy to use and visually appealing?
    Technical choices: Were the necessary technologies and libraries used appropriately?
    Live component: Does the live component work as expected and meet the requirements?

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
