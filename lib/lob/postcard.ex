defmodule Lob.Postcard do
  @moduledoc """
  Module implementing the Lob postcards API.
  """

  use Lob.ResourceBase, endpoint: "postcards", methods: [:create, :retrieve, :list, :delete]
end
