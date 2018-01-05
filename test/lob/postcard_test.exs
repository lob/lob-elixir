defmodule Lob.PostcardTest do
  use ExUnit.Case

  alias Lob.Postcard

  setup do
    sample_address = %{
      name: "TestAddress",
      email: "test@test.com",
      address_line1: "185 Berry Street",
      address_line2: "Suite 6100",
      address_city: "San Francisco",
      address_state: "CA",
      address_country: "US",
      address_zip: "94107"
    }

    sample_postcard = %{
      description: "Library Test Postcard #{DateTime.utc_now |> DateTime.to_string}",
      back: "<h1>Sample postcard back</h1>"
    }

    # TODO(anthony): Once address API is added to wrapper, replace this ID with a created address
    %{
      test_address_id: "adr_a7d78be7f746a0a7",
      sample_address: sample_address,
      sample_postcard: sample_postcard
    }
  end

  describe "list/2" do

    test "lists postcards" do
      {:ok, postcards, _headers} = Postcard.list()
      assert postcards.object == "list"
    end

    test "includes total count" do
      {:ok, postcards, _headers} = Postcard.list(%{include: ["total_count"]})
      assert Map.get(postcards, :total_count) != nil
    end

    test "lists by limit" do
      {:ok, postcards, _headers} = Postcard.list(%{limit: 2})
      assert postcards.count == 2
    end

    test "filters by metadata" do
      {:ok, postcards, _headers} = Postcard.list(%{metadata: %{foo: "bar"}})
      assert postcards.count == 1
    end

  end

  describe "retrieve/2" do

    test "retrieves a postcard", %{test_address_id: test_address_id, sample_postcard: sample_postcard} do
      {:ok, created_postcard, _headers} =
        Postcard.create(%{
          description: sample_postcard.description,
          to: test_address_id,
          front: "https://lob.com/postcardfront.pdf",
          back: "https://lob.com/postcardback.pdf"
        })

      {:ok, retrieved_postcard, _headers} = Postcard.retrieve(created_postcard.id)
      assert retrieved_postcard.description == created_postcard.description
    end

  end

  describe "create/2" do

    test "creates a postcard with address_id", %{test_address_id: test_address_id, sample_postcard: sample_postcard} do
      {:ok, created_postcard, headers} =
        Postcard.create(%{
          description: sample_postcard.description,
          to: test_address_id,
          front: "https://lob.com/postcardfront.pdf",
          back: sample_postcard.back
        })

      assert created_postcard.description == sample_postcard.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a postcard with to address params", %{sample_postcard: sample_postcard, sample_address: sample_address} do
      {:ok, created_postcard, headers} =
        Postcard.create(%{
          description: sample_postcard.description,
          to: sample_address,
          front: "https://lob.com/postcardfront.pdf",
          back: sample_postcard.back
        })

      assert created_postcard.description == sample_postcard.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a postcard with from address params", %{test_address_id: test_address_id, sample_postcard: sample_postcard, sample_address: sample_address} do
      {:ok, created_postcard, headers} =
        Postcard.create(%{
          description: sample_postcard.description,
          to: test_address_id,
          from: sample_address,
          front: "https://lob.com/postcardfront.pdf",
          back: sample_postcard.back
        })

      assert created_postcard.description == sample_postcard.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a postcard with front and back as urls", %{test_address_id: test_address_id, sample_postcard: sample_postcard} do
      {:ok, created_postcard, headers} =
        Postcard.create(%{
          description: sample_postcard.description,
          to: test_address_id,
          front: "https://lob.com/postcardfront.pdf",
          back: "https://lob.com/postcardback.pdf"
        })

      assert created_postcard.description == sample_postcard.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a postcard with front and back as PDFs", %{test_address_id: test_address_id, sample_postcard: sample_postcard} do
      {:ok, created_postcard, headers} =
        Postcard.create(%{
          description: sample_postcard.description,
          to: test_address_id,
          front: %{local_path: "test/assets/postcardfront.pdf"},
          back: %{local_path: "test/assets/postcardback.pdf"}
        })

      assert created_postcard.description == sample_postcard.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a postcard with an idempotency key", %{test_address_id: test_address_id, sample_postcard: sample_postcard} do
      idempotency_key = UUID.uuid4()

      {:ok, created_postcard, _headers} =
        Postcard.create(%{
          description: sample_postcard.description,
          to: test_address_id,
          front: %{local_path: "test/assets/postcardfront.pdf"},
          back: %{local_path: "test/assets/postcardback.pdf"}
        }, %{
          "Idempotency-Key" => idempotency_key
        })

      {:ok, duplicated_postcard, _headers} =
        Postcard.create(%{
          description: "Duplicated Postcard",
          to: test_address_id,
          front: %{local_path: "test/assets/postcardfront.pdf"},
          back: %{local_path: "test/assets/postcardback.pdf"}
        }, %{
          "Idempotency-Key" => idempotency_key
        })

      assert created_postcard.description == duplicated_postcard.description
    end

  end

  describe "delete/2" do

    test "destroys a postcard", %{test_address_id: test_address_id, sample_postcard: sample_postcard} do
      {:ok, created_postcard, _headers} =
        Postcard.create(%{
          description: sample_postcard.description,
          to: test_address_id,
          front: "https://lob.com/postcardfront.pdf",
          back: "https://lob.com/postcardback.pdf"
        })

        {:ok, deleted_postcard, _headers} = Postcard.delete(created_postcard.id)
        assert deleted_postcard.id == created_postcard.id
        assert deleted_postcard.deleted == true
    end

  end

end
