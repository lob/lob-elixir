defmodule Lob.IntlVerificationTest do
  use ExUnit.Case

  alias Lob.IntlVerification

  setup do
    %{
      sample_address: %{
        primary_line: "123 Test St",
        city: "HEARST",
        state: "ONTARIO",
        postal_code: "P0L1N0",
        country: "CA"
      }
    }
  end

  describe "verify/2" do

    test "returns a 403 in test mode", %{sample_address: sample_address} do
      {:error, message} = IntlVerification.verify(sample_address)
      assert message.status_code == 403
    end

  end

end
