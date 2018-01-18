defmodule Lob.LetterTest do
  use ExUnit.Case

  alias Lob.Letter

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

    sample_letter = %{
      description: "Library Test Letter #{DateTime.utc_now |> DateTime.to_string}"
    }

    # TODO(anthony): Once address API is added to wrapper, replace this ID with a created address
    %{
      test_address_id: "adr_a7d78be7f746a0a7",
      sample_address: sample_address,
      sample_letter: sample_letter
    }
  end

  describe "list/2" do

    test "lists letters" do
      {:ok, letters, _headers} = Letter.list()
      assert letters.object == "list"
    end

    test "includes total count" do
      {:ok, letters, _headers} = Letter.list(%{include: ["total_count"]})
      assert Map.get(letters, :total_count) != nil
    end

    test "lists by limit" do
      {:ok, letters, _headers} = Letter.list(%{limit: 2})
      assert letters.count == 2
    end

    test "filters by metadata" do
      {:ok, letters, _headers} = Letter.list(%{metadata: %{foo: "bar"}})
      assert letters.count == 1
    end

  end

  describe "retrieve/2" do

    test "retrieves a letter", %{test_address_id: test_address_id, sample_letter: sample_letter} do
      {:ok, created_letter, _headers} =
        Letter.create(%{
          description: sample_letter.description,
          to: test_address_id,
          from: test_address_id,
          color: true,
          file: "https://s3-us-west-2.amazonaws.com/lob-assets/letter-goblue.pdf"
        })

      {:ok, retrieved_letter, _headers} = Letter.retrieve(created_letter.id)
      assert retrieved_letter.description == created_letter.description
    end

  end

  describe "create/2" do

    test "creates a letter with address_id", %{test_address_id: test_address_id, sample_letter: sample_letter} do
      {:ok, created_letter, headers} =
        Letter.create(%{
          description: sample_letter.description,
          to: test_address_id,
          from: test_address_id,
          color: true,
          file: "https://s3-us-west-2.amazonaws.com/lob-assets/letter-goblue.pdf"
        })

      assert created_letter.description == sample_letter.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a letter with address params", %{sample_letter: sample_letter, sample_address: sample_address} do
      {:ok, created_letter, headers} =
        Letter.create(%{
          description: sample_letter.description,
          to: sample_address,
          from: sample_address,
          color: true,
          file: "https://s3-us-west-2.amazonaws.com/lob-assets/letter-goblue.pdf"
        })

      assert created_letter.description == sample_letter.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a letter with file as PDF", %{test_address_id: test_address_id, sample_letter: sample_letter} do
      {:ok, created_letter, headers} =
        Letter.create(%{
          description: sample_letter.description,
          to: test_address_id,
          from: test_address_id,
          color: true,
          file: %{local_path: "test/assets/8.5x11.pdf"}
        })

      assert created_letter.description == sample_letter.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a letter with an idempotency key", %{test_address_id: test_address_id, sample_letter: sample_letter} do
      idempotency_key = UUID.uuid4()

      {:ok, created_letter, _headers} =
        Letter.create(%{
          description: sample_letter.description,
          to: test_address_id,
          from: test_address_id,
          color: true,
          file: %{local_path: "test/assets/8.5x11.pdf"}
        }, %{
          "Idempotency-Key" => idempotency_key
        })

      {:ok, duplicated_letter, _headers} =
        Letter.create(%{
          description: "Duplicated Letter",
          to: test_address_id,
          from: test_address_id,
          color: true,
          file: %{local_path: "test/assets/8.5x11.pdf"}
        }, %{
          "Idempotency-Key" => idempotency_key
        })

      assert created_letter.description == duplicated_letter.description
    end

  end

  describe "delete/2" do

    test "deletes a letter", %{test_address_id: test_address_id, sample_letter: sample_letter} do
      {:ok, created_letter, _headers} =
        Letter.create(%{
          description: sample_letter.description,
          to: test_address_id,
          from: test_address_id,
          color: true,
          file: %{local_path: "test/assets/8.5x11.pdf"}
        })

        {:ok, deleted_letter, _headers} = Letter.delete(created_letter.id)
        assert deleted_letter.id == created_letter.id
        assert deleted_letter.deleted == true
    end

  end

end
