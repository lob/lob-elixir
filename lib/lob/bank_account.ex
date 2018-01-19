defmodule Lob.BankAccount do
  @moduledoc """
  Module implementing the Lob bank accounts API.
  """

  use Lob.ResourceBase, endpoint: "bank_accounts", methods: [:create, :retrieve, :list, :delete]

  @spec verify(String.t, map, map) :: Client.response
  def verify(id, data, headers \\ %{}) do
    Client.post_request(verify_url(id), Util.build_body(data), Util.build_headers(headers))
  end

  defp verify_url(resource_id), do: "#{resource_url(resource_id)}/verify"

end
