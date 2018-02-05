defmodule Lob.ResourceBase do
  @moduledoc """
  Module representing the base Lob resource.
  """

  defmacro __using__(opts) do
    endpoint = Keyword.fetch!(opts, :endpoint)
    methods = Keyword.fetch!(opts, :methods)

    quote do
      @api_url "https://api.lob.com/v1"

      alias Lob.Util
      alias Lob.Client

      if :list in unquote(methods) do
        @spec list(map, map) :: Client.response
        def list(params \\ %{}, headers \\ %{}) do
          Client.get_request("#{base_url()}?#{Util.build_query_string(params)}" , Util.build_headers(headers))
        end
      end

      if :retrieve in unquote(methods) do
        @spec retrieve(String.t, map) :: Client.response
        def retrieve(id, headers \\ %{}) do
          Client.get_request(resource_url(id), Util.build_headers(headers))
        end
      end

      if :create in unquote(methods) do
        @spec create(map, map) :: Client.response
        def create(data, headers \\ %{}) do
          Client.post_request(base_url(), Util.build_body(data), Util.build_headers(headers))
        end
      end

      if :delete in unquote(methods) do
        @spec delete(String.t, map) :: Client.response
        def delete(id, headers \\ %{}) do
          Client.delete_request(resource_url(id), Util.build_headers(headers))
        end
      end

      @spec base_url :: String.t
      defp base_url, do: "#{@api_url}/#{unquote(endpoint)}"

      @spec resource_url(String.t) :: String.t
      defp resource_url(resource_id), do: "#{base_url()}/#{resource_id}"
    end

  end

end
