defmodule Lob.SelfMailer do
  @moduledoc """
  Module implementing the Lob self mailer API.
  """

  use Lob.ResourceBase, endpoint: "self_mailers", methods: [:create, :retrieve, :list, :delete]

end
