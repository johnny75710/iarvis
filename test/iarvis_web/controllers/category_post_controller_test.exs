defmodule IarvisWeb.CategoryPostControllerTest do
  use IarvisWeb.ConnCase

  import Iarvis.BlogFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index posts by category" do
    test "lists all posts for a category with empty data", %{conn: conn} do
      # Crear una categoría para las pruebas
      category = category_fixture()

      # Solicitar posts para esa categoría (que no tendrá ninguno)
      conn = get(conn, ~p"/api/categories/#{category.id}/posts")
      response = json_response(conn, 200)

      # Verificar estructura de respuesta
      assert %{"posts" => [], "meta" => %{"pagination" => pagination}} = response

      assert %{
               "limit" => 10,
               "offset" => 0,
               "total_count" => 0,
               "has_more" => false,
               "last_id" => nil
             } = pagination
    end

    test "returns 404 for non-existent category", %{conn: conn} do
      # Intentar obtener posts de una categoría que no existe
      conn = get(conn, ~p"/api/categories/00000000-0000-0000-0000-000000000000/posts")
      assert json_response(conn, 404)["errors"] != %{}
    end
  end
end
