defmodule Lob.Util do
  @moduledoc """
  Module responsible for transforming arguments for requests.
  """

  @doc """
  Transforms a map of request params to a URL encoded query string.

  ## Example
    iex> Lob.Util.build_query_string(%{count: 1, include: ["total_count"], metadata: %{name: "Larry"}})
    "count=1&include%5B%5D=total_count&metadata%5Bname%5D=Larry"
  """
  @spec build_query_string(map) :: String.t
  def build_query_string(params) when is_map(params) do
    params
    |> Enum.reduce([], &(&2 ++ transform_argument(&1)))
    |> URI.encode_query()
  end

  @doc """
  Transforms a map to a tuple recognized by HTTPoison/hackney for use as a
  multipart request body.

  ## Example
    iex> Lob.Util.build_body(%{description: "body", to: %{name: "Larry", species: "Lobster"}, front: %{local_path: "a/b/c"}})
    {:multipart, [{"description", "body"}, {:file, "a/b/c", {"form-data", [name: "front", filename: "a/b/c"]}, []}, {"to[name]", "Larry"}, {"to[species]", "Lobster"}]}
  """
  @spec build_body(map) :: {:multipart, list}
  def build_body(body) when is_map(body) do
    {:multipart, Enum.reduce(body, [], &(&2 ++ transform_argument(&1)))}
  end

  @doc """
  Transforms a map to a list of tuples recognized by HTTPoison/hackeny for use
  as request headers.

  ## Example
    iex> Lob.Util.build_headers(%{"Idempotency-Key" => "abc123", "Lob-Version" => "2017-11-08"})
    [{"Idempotency-Key", "abc123"}, {"Lob-Version", "2017-11-08"}]
  """
  @spec build_headers(list({any, any})) :: HTTPoison.Base.headers
  def build_headers(headers) do
    headers
    |> Enum.to_list
    |> Enum.map(fn {k, v} -> {to_string(k), to_string(v)} end)
  end

  @spec transform_argument({any, any}) :: list
  defp transform_argument({k, v}) when is_list(v) do
    Enum.map(v, fn e ->
      {"#{to_string(k)}[]", to_string(e)}
    end)
  end

  # For context on the format of the struct see:
  # https://github.com/benoitc/hackney/issues/292
  defp transform_argument({k, %{local_path: file_path}}) do
    [{:file, file_path, {"form-data", [name: to_string(k), filename: file_path]}, []}]
  end

  defp transform_argument({k, v}) when is_map(v) do
    Enum.map(v, fn {sub_k, sub_v} ->
      {"#{to_string(k)}[#{to_string(sub_k)}]", to_string(sub_v)}
    end)
  end

  defp transform_argument({k, v}) do
    [{to_string(k), to_string(v)}]
  end
end
