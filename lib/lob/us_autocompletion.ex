defmodule Lob.USAutocompletion do
  @moduledoc """
  Module implementing the Lob US Autocompletion API.
  """

  use Lob.ResourceBase, endpoint: "us_autocompletions", methods: []

  @spec autocomplete(map, map) :: Client.client_response
  def autocomplete(data, headers \\ %{}) do
    Client.post_request(base_url(), Util.build_body(data), Util.build_headers(headers))
  end
end
