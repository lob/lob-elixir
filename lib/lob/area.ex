defmodule Lob.Area do
  @moduledoc """
  Module implementing the Lob areas API.
  """

  use Lob.ResourceBase, endpoint: "areas", methods: [:create, :retrieve, :list]

end
