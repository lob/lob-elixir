defmodule Lob.BulkIntlVerification do
  @moduledoc """
  Module implementing the Lob bulk international verifications API.
  """

  use Lob.ResourceBase, endpoint: "bulk/intl_verifications", methods: []

  @spec verify(map, map) :: Client.client_response
  def verify(data, headers \\ %{"Content-type": "application/json"}) do
    Client.post_request(base_url(), Poison.encode!(data), Util.build_headers(headers))
  end

end
