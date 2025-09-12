defmodule IarvisWeb.CategoryControllerTest do
  use IarvisWeb.ConnCase

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
    test "lists all categories", %{conn: conn} do
      conn = get(conn, ~p"/api/categories")
      assert json_response(conn, 200)["categories"] == []
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
