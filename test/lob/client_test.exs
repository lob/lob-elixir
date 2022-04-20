defmodule Lob.ClientTest do
  use ExUnit.Case

  alias Lob.Client
  alias Lob.Client.MissingAPIKeyError
  alias Plug.Conn

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "api_key/1" do
    test "raises MissingAPIKeyError if no API key is found" do
      assert_raise(MissingAPIKeyError, fn ->
        api_key = System.get_env("API_KEY")
        System.delete_env("API_KEY")
        Client.api_key(nil)
        System.put_env("API_KEY", api_key)
      end)
    end
  end

  describe "get_request/2" do
    test "handles 2XX responses", %{bypass: bypass} do
      response_body = %{
        data: %{
          foo: "bar"
        }
      }

      Bypass.expect(bypass, fn conn ->
        conn
        |> Conn.put_resp_header("HeaderKey", "HeaderValue")
        |> Conn.resp(203, Poison.encode!(response_body))
      end)

      {:ok, body, headers} = Client.get_request(endpoint_url(bypass.port))
      assert response_body == body
      assert Enum.member?(headers, {"HeaderKey", "HeaderValue"})
    end

    test "handles non-2XX responses", %{bypass: bypass} do
      response_body = %{
        error: %{
          message: "resource not found",
          status_code: 404
        }
      }

      Bypass.expect(bypass, fn conn ->
        Conn.resp(conn, 404, Poison.encode!(response_body))
      end)

      {:error, error} = Client.get_request(endpoint_url(bypass.port))
      assert error == response_body.error
    end

    test "handles connection errors", %{bypass: bypass} do
      Bypass.down(bypass)
      {:error, %{message: error}} = Client.get_request(endpoint_url(bypass.port))
      assert error == ":econnrefused"
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
