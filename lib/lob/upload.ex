defmodule Lob.Upload do
  @moduledoc """
  uses Lob.ResourceBase to hit the uploads endpoint.
  """

  use Lob.ResourceBase,
    endpoint: "uploads",
    methods: [
      :list,
      :create,
      :create_json,
      :retrieve,
      :update,
      :delete,
      :upload_file,
      :create_export,
      :retrieve_export
    ]
end
