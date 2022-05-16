import Config

config :lob_elixir,
  api_key: System.get_env("LOB_API_TEST_KEY")

# config :pre_commit,
#   commands: ["test", "credo", "dialyzer", "coveralls"]
