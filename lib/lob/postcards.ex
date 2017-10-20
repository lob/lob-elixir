defmodule Lob.Postcards do
  @moduledoc """
  Module implementing the Lob postcards API.
  """

  use Lob.ResourceBase, [:create, :retrieve, :list, :delete]

  def endpoint, do: "postcards"

end
