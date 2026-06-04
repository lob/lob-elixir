import Config

config :lob_elixir,
  api_key: System.get_env("LOB_API_TEST_KEY")

# Cloudflare WARP does TLS inspection. Tell hackney to trust the system CA
# bundle (which already includes the Cloudflare Gateway CA via Kandji/Keychain)
# so SSL verification succeeds for outbound HTTPS requests.
config :lob_elixir,
  hackney_ssl_options: [
    verify: :verify_peer,
    cacerts: :public_key.cacerts_get()
  ]

# config :pre_commit,
#   commands: ["test", "credo", "dialyzer", "coveralls"]
