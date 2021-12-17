import Config

config :lob_elixir,
  api_key: System.get_env("API_KEY")

# config :pre_commit,
#   commands: ["test", "credo", "dialyzer", "coveralls"]
