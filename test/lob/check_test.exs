defmodule Lob.CheckTest do
  use ExUnit.Case

  alias Lob.Check

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

    sample_check = %{
      description: "Library Test Check #{DateTime.utc_now |> DateTime.to_string}",
      amount: 100
    }

    # TODO(anthony): Once address API is added to wrapper, replace this ID with a created address
    # TODO(anthony): Once bank account API is added to wrapper, replace this ID with a created bank account
    %{
      test_address_id: "adr_a7d78be7f746a0a7",
      test_bank_account_id: "bank_ffbb58dbc5a51d8",
      sample_address: sample_address,
      sample_check: sample_check
    }
  end

  describe "list/2" do

    test "lists checks" do
      {:ok, checks, _headers} = Check.list()
      assert checks.object == "list"
    end

    test "includes total count" do
      {:ok, checks, _headers} = Check.list(%{include: ["total_count"]})
      assert Map.get(checks, :total_count) != nil
    end

    test "lists by limit" do
      {:ok, checks, _headers} = Check.list(%{limit: 2})
      assert checks.count == 2
    end

    test "filters by metadata" do
      {:ok, checks, _headers} = Check.list(%{metadata: %{foo: "bar"}})
      assert checks.count == 1
    end

  end

  describe "retrieve/2" do

    test "retrieves a check", %{test_address_id: test_address_id, test_bank_account_id: test_bank_account_id, sample_check: sample_check} do
      {:ok, created_check, _headers} =
        Check.create(%{
          description: sample_check.description,
          to: test_address_id,
          from: test_address_id,
          bank_account: test_bank_account_id,
          amount: 42
        })

      {:ok, retrieved_check, _headers} = Check.retrieve(created_check.id)
      assert retrieved_check.description == created_check.description
    end

  end

  describe "create/2" do

    test "creates a check with address_id", %{test_address_id: test_address_id, test_bank_account_id: test_bank_account_id, sample_check: sample_check} do
      {:ok, created_check, headers} =
        Check.create(%{
          description: sample_check.description,
          to: test_address_id,
          from: test_address_id,
          bank_account: test_bank_account_id,
          amount: 42
        })

      assert created_check.description == sample_check.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a check with address params", %{sample_check: sample_check, test_bank_account_id: test_bank_account_id, sample_address: sample_address} do
      {:ok, created_check, headers} =
        Check.create(%{
          description: sample_check.description,
          to: sample_address,
          from: sample_address,
          bank_account: test_bank_account_id,
          amount: 42
        })

      assert created_check.description == sample_check.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a check with logo, attachment and check bottom as URL", %{test_address_id: test_address_id, test_bank_account_id: test_bank_account_id, sample_check: sample_check} do
      {:ok, created_check, headers} =
        Check.create(%{
          description: sample_check.description,
          to: test_address_id,
          from: test_address_id,
          bank_account: test_bank_account_id,
          amount: 42,
          logo: "http://via.placeholder.com/100x100",
          check_bottom: "https://s3-us-west-2.amazonaws.com/lob-assets/letter-goblue.pdf",
          attachment: "https://s3-us-west-2.amazonaws.com/lob-assets/letter-goblue.pdf"
        })

      assert created_check.description == sample_check.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a check with logo as PNG and attachment and check bottom as PDF", %{test_address_id: test_address_id, test_bank_account_id: test_bank_account_id, sample_check: sample_check} do
      {:ok, created_check, headers} =
        Check.create(%{
          description: sample_check.description,
          to: test_address_id,
          from: test_address_id,
          bank_account: test_bank_account_id,
          amount: 42,
          logo: %{local_path: "test/assets/logo.png"},
          check_bottom: %{local_path: "test/assets/8.5x11.pdf"},
          attachment: %{local_path: "test/assets/8.5x11.pdf"}
        })

      assert created_check.description == sample_check.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a check with an idempotency key", %{test_address_id: test_address_id, test_bank_account_id: test_bank_account_id, sample_check: sample_check} do
      idempotency_key = UUID.uuid4()

      {:ok, created_check, _headers} =
        Check.create(%{
          description: sample_check.description,
          to: test_address_id,
          from: test_address_id,
          bank_account: test_bank_account_id,
          amount: 42
        }, %{
          "Idempotency-Key" => idempotency_key
        })

      {:ok, duplicated_postcard, _headers} =
        Check.create(%{
          description: "Duplicated Check",
          to: test_address_id,
          from: test_address_id,
          bank_account: test_bank_account_id,
          amount: 42
        }, %{
          "Idempotency-Key" => idempotency_key
        })

      assert created_check.description == duplicated_postcard.description
    end

  end

  describe "delete/2" do

    test "deletes a check", %{test_address_id: test_address_id, test_bank_account_id: test_bank_account_id, sample_check: sample_check} do
      {:ok, created_check, _headers} =
        Check.create(%{
          description: sample_check.description,
          to: test_address_id,
          from: test_address_id,
          bank_account: test_bank_account_id,
          amount: 42
        })

        {:ok, deleted_check, _headers} = Check.delete(created_check.id)
        assert deleted_check.id == created_check.id
        assert deleted_check.deleted == true
    end

  end

end
