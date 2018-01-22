defmodule Lob.USZipLookup do
  @moduledoc """
  Module implementing the Lob US zip lookups API.
  """

  use Lob.ResourceBase, endpoint: "us_zip_lookups", methods: []

  @spec lookup(map, map) :: Client.response
  def lookup(data, headers \\ %{}) do
    Client.post_request(base_url(), Util.build_body(data), Util.build_headers(headers))
  end

end
