defmodule Lob.BulkUSVerification do
  @moduledoc """
  Module implementing the Lob bulk US verifications API.
  """
  use Lob.ResourceBase, endpoint: "bulk/us_verifications", methods: []

  #   The @spec for the function does not match the success typing of the function.

  # Function:
  # Lob.BulkUSVerification.verify/2

  # Success typing:
  # @spec verify(%{:addresses => [any()]}, map()) :: {:error, _} | {:ok, map(), [any()]}

  @spec verify(any, map()) :: {:error, any} | {:ok, map(), [any()]}
  def verify(data, headers \\ %{"Content-type": "application/json"}) do
    Client.post_request_binary(base_url(), Poison.encode!(data), Util.build_headers(headers))
  end
end
