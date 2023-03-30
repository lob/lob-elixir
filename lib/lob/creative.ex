defmodule Lob.Creative do
  @moduledoc """
  uses Lob.ResourceBase to hit the creatives endpoint.
  """

  use Lob.ResourceBase,
    endpoint: "creatives",
    methods: [
      :create,
      :retrieve,
      :update
    ]
end
