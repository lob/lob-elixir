defmodule Lob.Check do
  @moduledoc """
  Module implementing the Lob checks API.
  """

  use Lob.ResourceBase, endpoint: "checks", methods: [:create, :retrieve, :list, :delete]

end
