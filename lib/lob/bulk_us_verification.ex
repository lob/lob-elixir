defmodule Lob.BulkUSVerification do
  @moduledoc """
  Module implementing the Lob bulk US verifications API.
  """

  use Lob.ResourceBase, endpoint: "bulk/us_verifications", methods: []

  @spec verify(map, map) :: Client.client_response | no_return
  def verify(data, headers \\ %{"Content-type": "application/json"}) do
    Client.post_request(base_url(), Poison.encode!(data), Util.build_headers(headers))
  end

end
