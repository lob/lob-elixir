use Mix.Config

config :lob_elixir,
  api_endpoint: "https://api.lob.com/v1"

import_config "#{Mix.env}.exs"
