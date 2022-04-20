defmodule Lob.IntlVerification do
  @moduledoc """
  Module implementing the Lob international verifications API.
  """

  use Lob.ResourceBase, endpoint: "intl_verifications", methods: []

  @spec verify(map, map) :: Client.client_response()
  def verify(data, headers \\ %{}) do
    Client.post_request(base_url(), Util.build_body(data), Util.build_headers(headers))
  end
end
