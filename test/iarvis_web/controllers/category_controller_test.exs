defmodule IarvisWeb.CategoryControllerTest do
  use IarvisWeb.ConnCase

  import Iarvis.BlogFixtures

  @create_attrs %{
    name: "some name",
    description: "some description",
    slug: "some slug"
  }
  @invalid_attrs %{name: nil, description: nil, slug: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all categories with empty data", %{conn: conn} do
      conn = get(conn, ~p"/api/categories")
      response = json_response(conn, 200)

      # Verificar estructura de respuesta
      assert %{"data" => [], "meta" => %{"pagination" => pagination}} = response
      assert %{
        "limit" => 100,
        "offset" => 0,
        "total_count" => 0,
        "has_more" => false,
        "last_id" => nil
      } = pagination
    end

    test "lists categories with correct pagination", %{conn: conn} do
      # Crear 3 categorías de prueba
      category_fixture(%{name: "Category A", slug: "category-a"})
      category_fixture(%{name: "Category B", slug: "category-b"})
      category_fixture(%{name: "Category C", slug: "category-c"})

      # Probar con limit=2 para forzar paginación
      conn = get(conn, ~p"/api/categories?limit=2&offset=0")
      response = json_response(conn, 200)

      # Verificar que hay 2 categorías en la respuesta
      assert %{"data" => data, "meta" => %{"pagination" => pagination}} = response
      assert length(data) == 2

      # Verificar metadatos de paginación
      assert pagination["limit"] == 2
      assert pagination["offset"] == 0
      assert pagination["total_count"] == 3
      assert pagination["has_more"] == true
      assert pagination["last_id"] != nil

      # Verificar segunda página
      conn = get(conn, ~p"/api/categories?limit=2&offset=2")
      response = json_response(conn, 200)

      assert %{"data" => data, "meta" => %{"pagination" => pagination}} = response
      assert length(data) == 1
      assert pagination["has_more"] == false
    end
  end

  describe "create category" do
    test "renders category when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/category", category: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["category"]

      conn = get(conn, ~p"/api/category/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "name" => "some name",
               "slug" => "some slug"
             } = json_response(conn, 200)["category"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/category", category: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
