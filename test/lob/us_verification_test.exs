defmodule Lob.USVerificationTest do
  use ExUnit.Case

  alias Lob.USVerification

  setup do
    %{
      sample_address: %{
        recipient: "LOB.COM",
        primary_line: "185 BERRY ST STE 6600",
        city: "SAN FRANCISCO",
        state: "CA",
        zip_code: "94107"
      }
    }
  end

  describe "verify/2" do
    test "verifies a US address", %{sample_address: sample_address} do
      {:ok, verified_address, _headers} = USVerification.verify(sample_address)

      assert verified_address.recipient == "TEST KEYS DO NOT VERIFY ADDRESSES"

      assert verified_address.primary_line ==
               "SET `primary_line` TO 'deliverable' and `zip_code` to '11111' TO SIMULATE AN ADDRESS"

      assert verified_address.secondary_line ==
               "SEE https://www.lob.com/docs#us-verification-test-environment FOR MORE INFO"
    end
  end
end
