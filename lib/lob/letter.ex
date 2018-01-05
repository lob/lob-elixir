defmodule Lob.Letter do
  @moduledoc """
  Module implementing the Lob letters API.
  """

  use Lob.ResourceBase, endpoint: "letters", methods: [:create, :retrieve, :list, :delete]

end
