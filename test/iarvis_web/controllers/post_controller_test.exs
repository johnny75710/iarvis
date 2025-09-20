defmodule IarvisWeb.PostControllerTest do
  use IarvisWeb.ConnCase

  @create_attrs %{
    title: "some title",
    slug: "some slug",
    content: "some content",
    excerpt: "some excerpt",
    featured_image: "some featured_image",
    author_name: "some author_name",
    author_email: "some author_email",
    status: "published",
    is_featured: true,
    view_count: 42,
    published_at: ~U[2025-09-12 21:33:00Z]
  }

  @invalid_attrs %{
    status: nil,
    title: nil,
    slug: nil,
    content: nil,
    excerpt: nil,
    featured_image: nil,
    author_name: nil,
    author_email: nil,
    is_featured: nil,
    view_count: nil,
    published_at: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all posts with empty data", %{conn: conn} do
      conn = get(conn, ~p"/api/posts")
      response = json_response(conn, 200)

      assert %{"posts" => [], "meta" => %{"pagination" => pagination}} = response

      assert %{
               "limit" => 10,
               "offset" => 0,
               "total_count" => 0,
               "has_more" => false,
               "last_id" => nil
             } = pagination
    end
  end

  describe "create post" do
    test "renders post when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/posts", post: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["post"]

      conn = get(conn, ~p"/api/posts/#{id}")

      assert %{
               "id" => ^id,
               "title" => "some title",
               "slug" => "some slug",
               "content" => "some content",
               "excerpt" => "some excerpt",
               "featured_image" => "some featured_image",
               "author_name" => "some author_name",
               "author_email" => "some author_email",
               "status" => "published",
               "is_featured" => true,
               "view_count" => 42,
               "published_at" => "2025-09-12T21:33:00Z",
               "category_id" => nil
             } = json_response(conn, 200)["post"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/posts", post: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "creates post with category_id when provided", %{conn: conn} do
      # Primero creamos una categoría
      category_attrs = %{
        name: "Test Category",
        description: "Test Description",
        slug: "test-category"
      }
      conn_category = post(conn, ~p"/api/categories", category: category_attrs)
      assert %{"id" => category_id} = json_response(conn_category, 201)["category"]

      # Ahora creamos un post con esa categoría
      post_attrs = Map.put(@create_attrs, :category_id, category_id)
      conn = post(conn, ~p"/api/posts", post: post_attrs)
      assert %{"id" => post_id} = json_response(conn, 201)["post"]

      # Verificamos que el post tiene la categoría asignada
      conn = get(conn, ~p"/api/posts/#{post_id}")
      response = json_response(conn, 200)["post"]
      assert response["category_id"] == category_id
    end

    test "creates post with category_name creating new category", %{conn: conn} do
      post_attrs = Map.put(@create_attrs, :category_name, "New Category from API")
      post_attrs = Map.put(post_attrs, :slug, "unique-slug-#{System.unique_integer()}")

      conn = post(conn, ~p"/api/posts", post: post_attrs)
      assert %{"id" => post_id} = json_response(conn, 201)["post"]

      # Verificamos que el post se creó correctamente
      conn = get(conn, ~p"/api/posts/#{post_id}")
      response = json_response(conn, 200)["post"]

      # Verificamos que tiene un category_id asignado
      assert response["category_id"] != nil

      # Verificamos que la categoría se creó correctamente
      category_id = response["category_id"]
      conn = get(conn, ~p"/api/categories/#{category_id}")
      category_response = json_response(conn, 200)["category"]
      assert category_response["name"] == "New Category from API"
    end

    test "creates post with category_name using existing category", %{conn: conn} do
      # Primero creamos una categoría
      category_attrs = %{
        name: "Existing Category",
        description: "Existing Description",
        slug: "existing-category"
      }
      conn_category = post(conn, ~p"/api/categories", category: category_attrs)
      assert %{"id" => existing_category_id} = json_response(conn_category, 201)["category"]

      # Ahora creamos un post usando el nombre de la categoría existente
      post_attrs = Map.put(@create_attrs, :category_name, "Existing Category")
      post_attrs = Map.put(post_attrs, :slug, "unique-slug-#{System.unique_integer()}")

      conn = post(conn, ~p"/api/posts", post: post_attrs)
      assert %{"id" => post_id} = json_response(conn, 201)["post"]

      # Verificamos que usa la categoría existente
      conn = get(conn, ~p"/api/posts/#{post_id}")
      response = json_response(conn, 200)["post"]
      assert response["category_id"] == existing_category_id
    end
  end
end
