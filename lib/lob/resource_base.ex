defmodule Lob.ResourceBase do
  @moduledoc """
  Module representing the base Lob resource.
  """

  defmacro __using__(opts) do
    endpoint = Keyword.fetch!(opts, :endpoint)
    methods = Keyword.fetch!(opts, :methods)

    quote do
      @default_api_host "https://api.lob.com/v1"

      alias Lob.Client
      alias Lob.Util

      if :list in unquote(methods) do
        @spec list(map, map) :: Client.client_response()
        def list(params \\ %{}, headers \\ %{}) do
          Client.get_request(
            "#{base_url()}?#{Util.build_query_string(params)}",
            Util.build_headers(headers)
          )
        end

        @spec list!(map, map) :: {map, list} | no_return
        def list!(params \\ %{}, headers \\ %{}) do
          case list(params, headers) do
            {:ok, body, headers} -> {body, headers}
            {:error, error} -> raise to_string(error)
          end
        end
      end

      if :retrieve in unquote(methods) do
        @spec retrieve(String.t(), map) :: Client.client_response()
        def retrieve(id, headers \\ %{}) do
          Client.get_request(resource_url(id), Util.build_headers(headers))
        end

        @spec retrieve!(String.t(), map) :: {map, list} | no_return
        def retrieve!(id, headers \\ %{}) do
          case retrieve(id, headers) do
            {:ok, body, headers} -> {body, headers}
            {:error, error} -> raise to_string(error)
          end
        end
      end

      if :create in unquote(methods) do
        @spec create(map, map, boolean) :: Client.client_response()
        def create(data, headers \\ %{}, json \\ false) do
          if json == true do
            Client.post_request_json(base_url(), data, Util.build_headers(headers))
          else
            Client.post_request(base_url(), Util.build_body(data), Util.build_headers(headers))
          end
        end

        @spec create!(map, map, boolean) :: {map, list} | no_return
        def create!(data, headers \\ %{}, json \\ false) do
          case create(data, headers, json) do
            {:ok, body, headers} -> {body, headers}
            {:error, error} -> raise to_string(error)
          end
        end
      end

      if :upload_file in unquote(methods) do
        @spec upload_file(String.t(), map, map) :: Client.client_response()
        def upload_file(id, data, headers \\ %{}) do
          Client.post_request(
            resource_url(id),
            Util.build_body(data),
            Util.build_headers(headers)
          )
        end

        @spec upload_file!(String.t(), map, map) :: {map, list} | no_return
        def upload_file!(id, data, headers \\ %{}) do
          case upload_file(id, data, headers) do
            {:ok, body, headers} -> {body, headers}
            {:error, error} -> raise to_string(error)
          end
        end
      end

      if :delete in unquote(methods) do
        @spec delete(String.t(), map) :: Client.client_response()
        def delete(id, headers \\ %{}) do
          Client.delete_request(resource_url(id), Util.build_headers(headers))
        end

        @spec delete!(String.t(), map) :: {map, list} | no_return
        def delete!(id, headers \\ %{}) do
          case delete(id, headers) do
            {:ok, body, headers} -> {body, headers}
            {:error, error} -> raise to_string(error)
          end
        end
      end

      @spec base_url :: <<_::64, _::_*8>>
      defp base_url do
        "#{api_host()}/#{unquote(endpoint)}"
      end

      @spec api_host :: <<_::64, _::_*8>>
      defp api_host do
        "#{Application.get_env(:lob_elixir, :api_host, @default_api_host)}"
      end

      @spec resource_url(String.t()) :: <<_::64, _::_*8>>
      defp resource_url(resource_id) do
        "#{base_url()}/#{resource_id}"
      end
    end
  end
end
