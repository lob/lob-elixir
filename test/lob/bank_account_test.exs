defmodule Lob.BankAccountTest do
  use ExUnit.Case

  alias Lob.BankAccount

  setup do
    %{
      sample_bank_account: %{
        routing_number: "122100024",
        account_number: "123456789",
        account_type: "company",
        signatory: "John Doe"
      }
    }
  end

  describe "list/2" do
    test "lists bank accounts" do
      {:ok, bank_accounts, _headers} = BankAccount.list()
      assert bank_accounts.object == "list"
    end

    test "includes total count" do
      {:ok, bank_accounts, _headers} = BankAccount.list(%{include: ["total_count"]})
      assert Map.get(bank_accounts, :total_count) != nil
    end

    test "lists by limit" do
      {:ok, bank_accounts, _headers} = BankAccount.list(%{limit: 2})
      assert bank_accounts.count == 2
    end

    test "filters by metadata" do
      {:ok, bank_accounts, _headers} = BankAccount.list(%{metadata: %{foo: "bar"}})
      assert bank_accounts.count == 1
    end
  end

  describe "retrieve/2" do
    test "retrieves a bank account", %{sample_bank_account: sample_bank_account} do
      {:ok, created_bank_account, _headers} = BankAccount.create(sample_bank_account)

      {:ok, retrieved_bank_account, _headers} = BankAccount.retrieve(created_bank_account.id)
      assert retrieved_bank_account.account_number == created_bank_account.account_number
    end
  end

  describe "create/2" do
    test "creates a bank account", %{sample_bank_account: sample_bank_account} do
      {:ok, created_bank_account, headers} = BankAccount.create(sample_bank_account)

      assert created_bank_account.account_number == sample_bank_account.account_number
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a bank account with metadata", %{sample_bank_account: sample_bank_account} do
      {:ok, created_bank_account, headers} =
        sample_bank_account
        |> Map.merge(%{metadata: %{key: "value"}})
        |> BankAccount.create()

      assert created_bank_account.account_number == sample_bank_account.account_number
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end
  end

  describe "delete/2" do
    test "deletes a bank account", %{sample_bank_account: sample_bank_account} do
      {:ok, created_bank_account, _headers} = BankAccount.create(sample_bank_account)

      {:ok, deleted_bank_account, _headers} = BankAccount.delete(created_bank_account.id)
      assert deleted_bank_account.id == created_bank_account.id
      assert deleted_bank_account.deleted == true
    end
  end

  describe "verify/3" do
    test "verifies a bank account", %{sample_bank_account: sample_bank_account} do
      {:ok, created_bank_account, _headers} = BankAccount.create(sample_bank_account)

      {:ok, verified_bank_account, _headers} =
        BankAccount.verify(created_bank_account.id, %{amounts: [12, 34]})

      assert created_bank_account.id == verified_bank_account.id
      assert verified_bank_account.verified == true
    end
  end
end
