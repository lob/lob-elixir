defmodule Lob.Address do
  @moduledoc """
  Module implementing the Lob addresses API.
  """

  use Lob.ResourceBase, endpoint: "addresses", methods: [:create, :retrieve, :list, :delete]

end
