import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :form_questionnaire, FormQuestionnaire.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "form_questionnaire_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :form_questionnaire, FormQuestionnaireWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "hxULj6U2XAOtbfODc4Dwx8bbXfGB+n1T4KH51a8Bsz7huOS4Ihw1XMdZG5bW/PeI",
  server: false

# In test we don't send emails.
config :form_questionnaire, FormQuestionnaire.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
