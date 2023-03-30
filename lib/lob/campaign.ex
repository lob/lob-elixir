defmodule Lob.Campaign do
  @moduledoc """
  uses Lob.ResourceBase to hit the campaigns endpoint.
  """

  use Lob.ResourceBase,
    endpoint: "campaigns",
    methods: [:list, :create, :retrieve, :update, :delete, :send_campaign]
end
