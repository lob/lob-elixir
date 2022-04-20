defmodule Lob.BulkIntlVerificationTest do
  use ExUnit.Case

  alias Lob.BulkIntlVerification

  setup do
    %{
      sample_address: %{
        primary_line: "deliverable",
        country: "CA"
      }
    }
  end

  describe "verify/2" do
    test "returns a dummy response in test mode", %{sample_address: sample_address} do
      {:ok, %{addresses: [verified_address]}, _headers} =
        BulkIntlVerification.verify(%{addresses: [sample_address]})

      assert verified_address.primary_line == "370 WATER ST"
      assert verified_address.deliverability == "deliverable"
    end
  end
end
