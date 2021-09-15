defmodule Lob.USReverseGeocodeLookupTest do
  use ExUnit.Case

  alias Lob.USReverseGeocodeLookup

  describe "lookup/2" do

    test "lookup a US location" do
      latitude = 37.777456
      longitude = -122.393039

      {:ok, result, _headers} = USReverseGeocodeLookup.lookup(%{latitude: latitude, longitude: longitude})

      assert (List.first(result.addresses).components.zip_code == "94102" or  List.first(result.addresses).components.zip_code == "94103")
      assert length(result.addresses) == 5
    end

  end

end
