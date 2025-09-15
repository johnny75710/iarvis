defmodule IarvisWeb.PostController do
  use IarvisWeb, :controller

  alias Iarvis.Blog
  alias Iarvis.Blog.Post

  action_fallback IarvisWeb.FallbackController

  def index(conn, params) do
    limit =
      params
      |> Map.get("limit", "10")
      |> parse_pagination_param(10)

    offset =
      params
      |> Map.get("offset", "0")
      |> parse_pagination_param(0)

    posts = Blog.list_posts(limit: limit, offset: offset)

    total_count = Blog.count_posts()

    has_more = offset + limit < total_count

    last_element = List.last(posts)

    pagination = %{
      limit: limit,
      offset: offset,
      total_count: total_count,
      has_more: has_more,
      last_id: if(last_element, do: last_element.id, else: nil)
    }

    render(conn, :index, posts: posts, pagination: pagination)
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Blog.create_post(post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/posts/#{post}")
      |> render(:show, post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    render(conn, :show, post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Blog.get_post!(id)

    with {:ok, %Post{} = post} <- Blog.update_post(post, post_params) do
      render(conn, :show, post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Blog.get_post!(id)

    with {:ok, %Post{}} <- Blog.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end

  defp parse_pagination_param(value, default) do
    case Integer.parse(value) do
      {int, _} when int > 0 -> int
      _ -> default
    end
  end
end
