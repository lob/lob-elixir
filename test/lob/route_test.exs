defmodule Lob.RouteTest do
  use ExUnit.Case

  alias Lob.Route

  describe "list/2" do

    test "lists routes with single zip" do
      zip_code = "94158"

      {:ok, %{data: [route | _t]} = routes, _headers} = Route.list(%{zip_codes: zip_code})
      assert routes.object == "list"
      assert route.zip_code == zip_code
    end

    test "lists routes with multiple zips" do
      zip_codes = [first_zip, second_zip] = ["94107", "94158"]

      {:ok, %{data: [first_route, second_route | _t]} = routes, _headers} = Route.list(%{zip_codes: zip_codes})
      assert routes.object == "list"
      assert first_route.zip_code == first_zip
      assert second_route.zip_code == second_zip
    end

  end

  describe "retrieve/2" do

    test "retrieves route" do
      zip_code = "94158"

      {:ok, retrieved_route, _headers} = Route.retrieve(zip_code)
      assert retrieved_route.zip_code == zip_code
    end

  end

end
