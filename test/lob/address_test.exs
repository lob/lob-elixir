defmodule Lob.AddressTest do
  use ExUnit.Case

  alias Lob.Address

  setup do
    %{
      sample_address: %{
        name: "TestAddress",
        email: "test@test.com",
        address_line1: "185 Berry Street",
        address_line2: "Suite 6100",
        address_city: "San Francisco",
        address_state: "CA",
        address_country: "US",
        address_zip: "94107"
      }
    }
  end

  describe "list/2" do

    test "lists addresses" do
      {:ok, addresses, _headers} = Address.list()
      assert addresses.object == "list"
    end

    test "includes total count" do
      {:ok, addresses, _headers} = Address.list(%{include: ["total_count"]})
      assert Map.get(addresses, :total_count) != nil
    end

    test "lists by limit" do
      {:ok, addresses, _headers} = Address.list(%{limit: 2})
      assert addresses.count == 2
    end

    test "filters by metadata" do
      {:ok, addresses, _headers} = Address.list(%{metadata: %{foo: "bar"}})
      assert addresses.count == 0
    end

  end

  describe "retrieve/2" do

    test "retrieves an address", %{sample_address: sample_address} do
      {:ok, created_address, _headers} = Address.create(sample_address)

      {:ok, retrieved_address, _headers} = Address.retrieve(created_address.id)
      assert retrieved_address.name == created_address.name
    end

  end

  describe "create/2" do

    test "creates an address", %{sample_address: sample_address} do
      {:ok, created_address, headers} = Address.create(sample_address)

      assert created_address.name == String.upcase(sample_address.name)
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates an address with metadata", %{sample_address: sample_address} do
      {:ok, created_address, headers} =
        sample_address
        |> Map.merge(%{metadata: %{key: "value"}})
        |> Address.create

      assert created_address.name == String.upcase(sample_address.name)
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

  end

  describe "delete/2" do

    test "deletes an address", %{sample_address: sample_address} do
      {:ok, created_address, _headers} = Address.create(sample_address)

      {:ok, deleted_address, _headers} = Address.delete(created_address.id)
      assert deleted_address.id == created_address.id
      assert deleted_address.deleted == true
    end

  end

end
