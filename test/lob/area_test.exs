defmodule Lob.AreaTest do
  use ExUnit.Case

  alias Lob.Area

  setup do
    %{
      sample_area: %{
        description: "Library Test Area #{DateTime.utc_now |> DateTime.to_string}",
        front: "https://s3-us-west-2.amazonaws.com/lob-assets/areafront.pdf",
        back: "https://s3-us-west-2.amazonaws.com/lob-assets/areaback.pdf",
        routes: ["94158-C001", "94107-C031"]
      }
    }
  end

  describe "list/2" do

    test "lists areas" do
      {:ok, areas, _headers} = Area.list()
      assert areas.object == "list"
    end

    test "includes total count" do
      {:ok, areas, _headers} = Area.list(%{include: ["total_count"]})
      assert Map.get(areas, :total_count) != nil
    end

    test "lists by limit" do
      {:ok, areas, _headers} = Area.list(%{limit: 2})
      assert areas.count == 2
    end

    test "filters by metadata" do
      {:ok, areas, _headers} = Area.list(%{metadata: %{foo: "bar"}})
      assert areas.count == 1
    end

  end

  describe "retrieve/2" do

    test "retrieves an area", %{sample_area: sample_area} do
      {:ok, created_area, _headers} = Area.create(sample_area)

      {:ok, retrieved_area, _headers} = Area.retrieve(created_area.id)
      assert retrieved_area.description == created_area.description
    end

  end

  describe "create/2" do

    test "creates an area", %{sample_area: sample_area} do
      {:ok, created_area, headers} = Area.create(sample_area)

      assert created_area.description == sample_area.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates an area with metadata", %{sample_area: sample_area} do
      {:ok, created_area, headers} =
        sample_area
        |> Map.merge(%{metadata: %{key: "value"}})
        |> Area.create()

      assert created_area.description == sample_area.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates an area with front and back as PDFs", %{sample_area: sample_area} do
      front_back_params = %{
        front: %{local_path: "test/assets/areafront.pdf"},
        back: %{local_path: "test/assets/areaback.pdf"}
      }

      {:ok, created_area, headers} =
        sample_area
        |> Map.merge(front_back_params)
        |> Area.create()

      assert created_area.description == sample_area.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "should create an area object with a single route", %{sample_area: sample_area} do
      {:ok, created_area, headers} =
        sample_area
        |> Map.merge(%{routes: "94158-C001"})
        |> Area.create()

      assert created_area.description == sample_area.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "should create an area object with zip_codes", %{sample_area: sample_area} do
      {:ok, created_area, headers} =
        sample_area
        |> Map.merge(%{routes: ["94158"]})
        |> Area.create()

      assert created_area.description == sample_area.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

  end

end
