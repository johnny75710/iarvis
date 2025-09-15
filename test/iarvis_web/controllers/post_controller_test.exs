defmodule IarvisWeb.PostControllerTest do
  use IarvisWeb.ConnCase

  @create_attrs %{
    status: "some status",
    title: "some title",
    slug: "some slug",
    content: "some content",
    excerpt: "some excerpt",
    featured_image: "some featured_image",
    author_name: "some author_name",
    author_email: "some author_email",
    is_featured: true,
    view_count: 42,
    published_at: ~U[2025-09-12 21:33:00Z]
  }

  @invalid_attrs %{status: nil, title: nil, slug: nil, content: nil, excerpt: nil, featured_image: nil, author_name: nil, author_email: nil, is_featured: nil, view_count: nil, published_at: nil}

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
               "author_email" => "some author_email",
               "author_name" => "some author_name",
               "content" => "some content",
               "excerpt" => "some excerpt",
               "featured_image" => "some featured_image",
               "is_featured" => true,
               "published_at" => "2025-09-12T21:33:00Z",
               "slug" => "some slug",
               "status" => "some status",
               "title" => "some title",
               "view_count" => 42
             } = json_response(conn, 200)["post"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/posts", post: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
