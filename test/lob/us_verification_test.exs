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

      assert verified_address.recipient == sample_address.recipient
      assert verified_address.primary_line == sample_address.primary_line
      assert verified_address.last_line == "SAN FRANCISCO CA 94107-1234"
    end

  end

end
