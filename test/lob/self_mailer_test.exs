defmodule Lob.SelfMailerTest do
  use ExUnit.Case

  alias Lob.Address
  alias Lob.SelfMailer

  setup do
    sample_address = %{
      name: "TestAddress",
      email: "test@test.com",
      address_line1: "210 King St",
      address_city: "San Francisco",
      address_state: "CA",
      address_country: "US",
      address_zip: "94107"
    }

    sample_self_mailer = %{
      description: "Library Test Self Mailer #{DateTime.utc_now() |> DateTime.to_string()}",
      outside: "<h1>Sample self mailer outside</h1>",
      inside:
        "https://s3-us-west-2.amazonaws.com/public.lob.com/assets/templates/self_mailers/6x18_sfm_inside.pdf"
    }

    %{
      sample_address: sample_address,
      sample_self_mailer: sample_self_mailer
    }
  end

  describe "list/2" do
    test "lists self mailers" do
      {:ok, self_mailers, _headers} = SelfMailer.list()
      assert self_mailers.object == "list"
    end

    test "includes total count" do
      {:ok, self_mailers, _headers} = SelfMailer.list(%{include: ["total_count"]})
      assert Map.get(self_mailers, :total_count) != nil
    end

    test "lists by limit" do
      {:ok, self_mailers, _headers} = SelfMailer.list(%{limit: 2})
      assert self_mailers.count == 2
    end

    test "filters by metadata" do
      {:ok, self_mailers, _headers} = SelfMailer.list(%{metadata: %{campaign: "LOB-TEST"}})
      assert self_mailers.count > 0
    end
  end

  describe "retrieve/2" do
    test "retrieves a self mailer", %{
      sample_address: sample_address,
      sample_self_mailer: sample_self_mailer
    } do
      {:ok, created_address, _headers} = Address.create(sample_address)

      {:ok, created_self_mailer, _headers} =
        SelfMailer.create(%{
          description: sample_self_mailer.description,
          to: created_address.id,
          outside:
            "https://s3-us-west-2.amazonaws.com/public.lob.com/assets/templates/self_mailers/6x18_sfm_outside.pdf",
          inside:
            "https://s3-us-west-2.amazonaws.com/public.lob.com/assets/templates/self_mailers/6x18_sfm_inside.pdf"
        })

      {:ok, retrieved_self_mailer, _headers} = SelfMailer.retrieve(created_self_mailer.id)
      assert retrieved_self_mailer.description == created_self_mailer.description
    end
  end

  describe "create/2" do
    test "creates a self mailer with address_id", %{
      sample_address: sample_address,
      sample_self_mailer: sample_self_mailer
    } do
      {:ok, created_address, _headers} = Address.create(sample_address)

      {:ok, created_self_mailer, headers} =
        SelfMailer.create(%{
          description: sample_self_mailer.description,
          to: created_address.id,
          outside: sample_self_mailer.outside,
          inside: sample_self_mailer.inside
        })

      assert created_self_mailer.description == sample_self_mailer.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a self mailer with to address params", %{
      sample_self_mailer: sample_self_mailer,
      sample_address: sample_address
    } do
      {:ok, created_self_mailer, headers} =
        SelfMailer.create(%{
          description: sample_self_mailer.description,
          to: sample_address,
          outside: sample_self_mailer.outside,
          inside: sample_self_mailer.inside
        })

      assert created_self_mailer.description == sample_self_mailer.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a self mailer with from address params", %{
      sample_address: sample_address,
      sample_self_mailer: sample_self_mailer
    } do
      {:ok, created_address, _headers} = Address.create(sample_address)

      {:ok, created_self_mailer, headers} =
        SelfMailer.create(%{
          description: sample_self_mailer.description,
          to: created_address.id,
          from: sample_address,
          outside:
            "https://s3-us-west-2.amazonaws.com/public.lob.com/assets/templates/self_mailers/6x18_sfm_outside.pdf",
          inside: sample_self_mailer.inside
        })

      assert created_self_mailer.description == sample_self_mailer.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a self mailer with outside and inside as urls", %{
      sample_address: sample_address,
      sample_self_mailer: sample_self_mailer
    } do
      {:ok, created_address, _headers} = Address.create(sample_address)

      {:ok, created_self_mailer, headers} =
        SelfMailer.create(%{
          description: sample_self_mailer.description,
          to: created_address.id,
          outside:
            "https://s3-us-west-2.amazonaws.com/public.lob.com/assets/templates/self_mailers/6x18_sfm_outside.pdf",
          inside:
            "https://s3-us-west-2.amazonaws.com/public.lob.com/assets/templates/self_mailers/6x18_sfm_inside.pdf"
        })

      assert created_self_mailer.description == sample_self_mailer.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a self mailer with outside and inside as PDFs", %{
      sample_address: sample_address,
      sample_self_mailer: sample_self_mailer
    } do
      {:ok, created_address, _headers} = Address.create(sample_address)

      {:ok, created_self_mailer, headers} =
        SelfMailer.create(%{
          description: sample_self_mailer.description,
          to: created_address.id,
          metadata: %{
            "campaign" => "LOB-TEST"
          },
          outside: %{local_path: "test/assets/sfm-6x18-outside.pdf"},
          inside: %{local_path: "test/assets/sfm-6x18-inside.pdf"}
        })

      assert created_self_mailer.description == sample_self_mailer.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a 12x9 self mailer with outside and inside as PDFs", %{
      sample_address: sample_address,
      sample_self_mailer: sample_self_mailer
    } do
      {:ok, created_address, _headers} = Address.create(sample_address)

      {:ok, created_self_mailer, headers} =
        SelfMailer.create(%{
          description: sample_self_mailer.description,
          to: created_address.id,
          size: "12x9_bifold",
          outside: %{local_path: "test/assets/sfm-12x9-outside.pdf"},
          inside: %{local_path: "test/assets/sfm-12x9-inside.pdf"}
        })

      assert created_self_mailer.description == sample_self_mailer.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end

    test "creates a self mailer with an idempotency key", %{
      sample_address: sample_address,
      sample_self_mailer: sample_self_mailer
    } do
      {:ok, created_address, _headers} = Address.create(sample_address)
      idempotency_key = UUID.uuid4()

      {:ok, created_self_mailer, _headers} =
        SelfMailer.create(
          %{
            description: sample_self_mailer.description,
            to: created_address.id,
            outside: %{local_path: "test/assets/sfm-6x18-outside.pdf"},
            inside: %{local_path: "test/assets/sfm-6x18-inside.pdf"}
          },
          %{
            "Idempotency-Key" => idempotency_key
          }
        )

      {:ok, duplicated_self_mailer, _headers} =
        SelfMailer.create(
          %{
            description: "Duplicated SelfMailer",
            to: created_address.id,
            outside: %{local_path: "test/assets/sfm-6x18-outside.pdf"},
            inside: %{local_path: "test/assets/sfm-6x18-inside.pdf"}
          },
          %{
            "Idempotency-Key" => idempotency_key
          }
        )

      assert created_self_mailer.description == duplicated_self_mailer.description
    end

    test "creates a self mailer with a merge variable list", %{
      sample_address: sample_address,
      sample_self_mailer: sample_self_mailer
    } do
      {:ok, created_address, _headers} = Address.create(sample_address)

      {:ok, created_self_mailer, headers} =
        SelfMailer.create(%{
          description: sample_self_mailer.description,
          to: created_address.id,
          outside: sample_self_mailer.outside,
          inside: "<html>{{#list}} {{name}} {{/list}}</html>",
          merge_variables: %{
            list: [
              %{
                name: "Larissa"
              },
              %{
                name: "Larry"
              }
            ]
          }
        })

      assert created_self_mailer.description == sample_self_mailer.description
      assert Enum.member?(headers, {"X-Rate-Limit-Limit", "150"})
    end
  end

  describe "delete/2" do
    test "deletes a self mailer", %{
      sample_address: sample_address,
      sample_self_mailer: sample_self_mailer
    } do
      {:ok, created_address, _headers} = Address.create(sample_address)

      {:ok, created_self_mailer, _headers} =
        SelfMailer.create(%{
          description: sample_self_mailer.description,
          to: created_address.id,
          outside: sample_self_mailer.outside,
          inside: sample_self_mailer.inside
        })

      {:ok, deleted_self_mailer, _headers} = SelfMailer.delete(created_self_mailer.id)
      assert deleted_self_mailer.id == created_self_mailer.id
      assert deleted_self_mailer.deleted == true
    end
  end
end
