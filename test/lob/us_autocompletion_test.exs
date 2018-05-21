defmodule Lob.USAutocompletionTest do
  use ExUnit.Case

  alias Lob.USAutocompletion

  describe "autocomplete/2" do

    test "autocompletes a US Address" do
      payload = %{
        address_prefix: "185 BER",
        city: "SAN FRANCISCO",
        state: "CA"
      }

      {:ok, result, _headers} = USAutocompletion.autocomplete(payload)

      assert result.id =~ ~r/^us_auto_/
      assert result.object == "us_autocompletion"
      assert length(result.suggestions) == 1

      assert result.suggestions |> List.first() |> Map.get(:primary_line) ==
               "TEST KEYS DO NOT AUTOCOMPLETE US ADDRESSES"
    end

  end

end
