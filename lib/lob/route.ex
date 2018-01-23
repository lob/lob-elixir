defmodule Lob.Route do
  @moduledoc """
  Module implementing the Lob routes API.
  """

  use Lob.ResourceBase, endpoint: "routes", methods: [:retrieve, :list]

end
