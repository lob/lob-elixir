defmodule Lob.Client do
  @moduledoc """
  Client responsible for making requests to Lob and handling the responses.
  """

  alias Poison.Parser
  alias HTTPoison.Error
  alias HTTPoison.Response

  use HTTPoison.Base

  @client_version Mix.Project.config[:version]

  @type response :: {:ok, map, list} | {:error, map}

  defmodule MissingAPIKeyError do
    @moduledoc """
    Exception for when a request is made without an API key.
    """

    defexception message: """
      The api_key setting is required to make requests to Lob.
      Please configure :api_key in config.exs or set the LOB_API_KEY
      environment variable.

      config :lob_elixir, api_key: API_KEY
    """
  end

  @spec version :: String.t
  def version do
    @client_version
  end

  @spec api_key(atom) :: String.t
  def api_key(env_key \\ :api_key) do
    case Application.get_env(:lob_elixir, env_key, System.get_env("LOB_API_KEY")) || :not_found do
      :not_found ->
        raise MissingAPIKeyError
      value -> value
    end
  end

  @spec api_version :: String.t
  def api_version, do: Application.get_env(:lob_elixir, :api_version, System.get_env "LOB_API_VERSION") || ""

  # #########################
  # HTTPoison.Base callbacks
  # #########################

  def process_request_headers(headers) do
    api_version()
    |> default_headers()
    |> Map.merge(Map.new(headers))
    |> Enum.into([])
  end

  def process_response_body(body) do
    Parser.parse!(body, keys: :atoms)
  end

  # #########################
  # Client API
  # #########################

  @spec get_request(String.t, HTTPoison.Base.headers) :: response
  def get_request(url, headers \\ []) do
    url
    |> get(headers, build_options())
    |> handle_response
  end

  @spec post_request(String.t, {:multipart, list}, HTTPoison.Base.headers) :: response
  def post_request(url, body, headers \\ []) do
    url
    |> post(body, headers, build_options())
    |> handle_response
  end

  @spec delete_request(String.t, HTTPoison.Base.headers) :: response
  def delete_request(url, headers \\ []) do
    url
    |> delete(headers, build_options())
    |> handle_response
  end

  # #########################
  # Response handlers
  # #########################

  @spec handle_response({:ok | :error, Response.t | Error.t}) :: response
  defp handle_response({:ok, %{body: body, headers: headers, status_code: code}})
  when code >= 200 and code < 300 do
    {:ok, body, headers}
  end

  defp handle_response({:ok, %{body: body}}) do
    {:error, body.error}
  end

  defp handle_response({:error, error = %Error{}}) do
    {:error, %{message: Error.message(error)}}
  end

  @spec build_options(String.t) :: Keyword.t
  defp build_options(api_key \\ api_key()) do
    [hackney: [pool: :default, basic_auth: {api_key, ""}]]
  end

  @spec default_headers(String.t) :: %{String.t => String.t}
  defp default_headers(api_version) do
    Map.new
    |> Map.put("User-Agent", "Lob/v1 ElixirBindings/#{version()}")
    |> Map.put("Lob-Version", api_version)
  end
end