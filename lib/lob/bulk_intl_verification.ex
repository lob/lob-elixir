defmodule Lob.BulkIntlVerification do
  @moduledoc """
  Module implementing the Lob bulk international verifications API.
  """

  use Lob.ResourceBase, endpoint: "bulk/intl_verifications", methods: []
  @spec verify(map, map) :: Client.client_response()
  def verify(data, headers \\ %{"Content-type": "application/json"}) do
    with {:ok, encoded_data} <- Poison.encode(data) do
      Client.post_request_binary(base_url(), encoded_data, Util.build_headers(headers))
    end
  end
end
