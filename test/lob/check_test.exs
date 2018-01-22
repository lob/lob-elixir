defmodule Lob.CheckTest do
  use ExUnit.Case

  alias Lob.Address
  alias Lob.BankAccount
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

    sample_bank_account = %{
      routing_number: "122100024",
      account_number: "123456789",
      account_type: "company",
      signatory: "John Doe"
    }

    sample_check = %{
      description: "Library Test Check #{DateTime.utc_now |> DateTime.to_string}",
      amount: 100
    }

    %{
      sample_address: sample_address,
      sample_bank_account: sample_bank_account,
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

    test "retrieves a check", %{sample_address: sample_address, sample_bank_account: sample_bank_account, sample_check: sample_check} do
      {:ok, created_address, _headers} = Address.create(sample_address)
      {:ok, verified_bank_account, _headers} = create_and_verify_bank_account(sample_bank_account)

      {:ok, created_check, _headers} =
        Check.create(%{
          description: sample_check.description,
          to: created_address.id,
          from: created_address.id,
          bank_account: verified_bank_account.id,
          amount: 42
        })

      {:ok, retrieved_check, _headers} = Check.retrieve(created_check.id)
      assert retrieved_check.description == created_check.description
    end

  end

  describe "create/2" do

    test "creates a check with address_id", %{sample_address: sample_address, sample_bank_account: sample_bank_account, sample_check: sample_check} do
      {:ok, created_address, _headers} = Address.create(sample_address)
      {:ok, verified_bank_account, _headers} = create_and_verify_bank_account(sample_bank_account)

      {:ok, created_check, headers} =
        Check.create(%{
          description: sample_check.description,
          to: created_address.id,
          from: created_address.id,
          bank_account: verified_bank_account.id,
          amount: 42
        })

      assert created_check.description == sample_check.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a check with address params", %{sample_check: sample_check, sample_bank_account: sample_bank_account, sample_address: sample_address} do
      {:ok, verified_bank_account, _headers} = create_and_verify_bank_account(sample_bank_account)

      {:ok, created_check, headers} =
        Check.create(%{
          description: sample_check.description,
          to: sample_address,
          from: sample_address,
          bank_account: verified_bank_account.id,
          amount: 42
        })

      assert created_check.description == sample_check.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a check with logo, attachment and check bottom as URL", %{sample_address: sample_address, sample_bank_account: sample_bank_account, sample_check: sample_check} do
      {:ok, created_address, _headers} = Address.create(sample_address)
      {:ok, verified_bank_account, _headers} = create_and_verify_bank_account(sample_bank_account)

      {:ok, created_check, headers} =
        Check.create(%{
          description: sample_check.description,
          to: created_address.id,
          from: created_address.id,
          bank_account: verified_bank_account.id,
          amount: 42,
          logo: "http://via.placeholder.com/100x100",
          check_bottom: "https://s3-us-west-2.amazonaws.com/lob-assets/letter-goblue.pdf",
          attachment: "https://s3-us-west-2.amazonaws.com/lob-assets/letter-goblue.pdf"
        })

      assert created_check.description == sample_check.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a check with logo as PNG and attachment and check bottom as PDF", %{sample_address: sample_address, sample_bank_account: sample_bank_account, sample_check: sample_check} do
      {:ok, created_address, _headers} = Address.create(sample_address)
      {:ok, verified_bank_account, _headers} = create_and_verify_bank_account(sample_bank_account)

      {:ok, created_check, headers} =
        Check.create(%{
          description: sample_check.description,
          to: created_address.id,
          from: created_address.id,
          bank_account: verified_bank_account.id,
          amount: 42,
          logo: %{local_path: "test/assets/logo.png"},
          check_bottom: %{local_path: "test/assets/8.5x11.pdf"},
          attachment: %{local_path: "test/assets/8.5x11.pdf"}
        })

      assert created_check.description == sample_check.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a check with an idempotency key", %{sample_address: sample_address, sample_bank_account: sample_bank_account, sample_check: sample_check} do
      {:ok, created_address, _headers} = Address.create(sample_address)
      {:ok, verified_bank_account, _headers} = create_and_verify_bank_account(sample_bank_account)

      idempotency_key = UUID.uuid4()

      {:ok, created_check, _headers} =
        Check.create(%{
          description: sample_check.description,
          to: created_address.id,
          from: created_address.id,
          bank_account: verified_bank_account.id,
          amount: 42
        }, %{
          "Idempotency-Key" => idempotency_key
        })

      {:ok, duplicated_postcard, _headers} =
        Check.create(%{
          description: "Duplicated Check",
          to: created_address.id,
          from: created_address.id,
          bank_account: verified_bank_account.id,
          amount: 42
        }, %{
          "Idempotency-Key" => idempotency_key
        })

      assert created_check.description == duplicated_postcard.description
    end

  end

  describe "delete/2" do

    test "deletes a check", %{sample_address: sample_address, sample_bank_account: sample_bank_account, sample_check: sample_check} do
      {:ok, created_address, _headers} = Address.create(sample_address)
      {:ok, verified_bank_account, _headers} = create_and_verify_bank_account(sample_bank_account)

      {:ok, created_check, _headers} =
        Check.create(%{
          description: sample_check.description,
          to: created_address.id,
          from: created_address.id,
          bank_account: verified_bank_account.id,
          amount: 42
        })

        {:ok, deleted_check, _headers} = Check.delete(created_check.id)
        assert deleted_check.id == created_check.id
        assert deleted_check.deleted == true
    end

  end

  defp create_and_verify_bank_account(payload) do
    payload
    |> BankAccount.create()
    |> elem(1)
    |> Map.get(:id)
    |> BankAccount.verify(%{amounts: [12, 34]})
  end

end
