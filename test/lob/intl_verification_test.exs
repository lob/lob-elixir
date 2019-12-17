defmodule Lob.IntlVerificationTest do
  use ExUnit.Case

  alias Lob.IntlVerification

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
      {:ok, response, _headers} =  = IntlVerification.verify(sample_address)
      assert response.primary_line == "370 WATER ST"
      assert response.deliverability == "deliverable"
    end

  end

end
