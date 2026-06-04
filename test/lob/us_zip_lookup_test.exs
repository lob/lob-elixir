defmodule Lob.USZipLookupTest do
  use ExUnit.Case

  alias Lob.USZipLookup

  describe "lookup/2" do
    test "lookup a US zip code" do
      {:ok, result, _headers} = USZipLookup.lookup(%{zip_code: "94107"})

      assert result.zip_code_type == "standard"
      assert length(result.cities) >= 1
    end
  end
end
