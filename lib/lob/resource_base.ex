defmodule Lob.ResourceBase do
  @moduledoc """
  Module representing the base Lob resource.
  """

  @callback endpoint() :: String.t

  defmacro __using__(opts) do
    quote do
      @behaviour Lob.ResourceBase

      alias Lob.Util
      alias Lob.Client

      if :list in unquote(opts) do
        @spec list(map, map) :: Client.response
        def list(params \\ %{}, headers \\ %{}) do
          Client.get_request(base_url() <> "?" <> Util.build_query_string(params), Util.build_headers(headers))
        end
      end

      if :retrieve in unquote(opts) do
        @spec retrieve(String.t, map) :: Client.response
        def retrieve(id, headers \\ %{}) do
          Client.get_request(resource_url(id), Util.build_headers(headers))
        end
      end

      if :create in unquote(opts) do
        @spec create(map, map) :: Client.response
        def create(data, headers \\ %{}) do
          Client.post_request(base_url(), Util.build_body(data), Util.build_headers(headers))
        end
      end

      if :delete in unquote(opts) do
        @spec delete(String.t, map) :: Client.response
        def delete(id, headers \\ %{}) do
          Client.delete_request(resource_url(id), Util.build_headers(headers))
        end
      end

      @spec base_url :: String.t
      defp base_url do
        "#{Application.get_env(:lob_elixir, :api_endpoint)}/#{endpoint()}"
      end

      @spec resource_url(String.t) :: String.t
      defp resource_url(resource_id) do
        "#{base_url()}/#{resource_id}"
      end
    end
  end

end
