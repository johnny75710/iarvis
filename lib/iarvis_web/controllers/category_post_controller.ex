defmodule IarvisWeb.CategoryPostController do
  use IarvisWeb, :controller

  alias Iarvis.Blog

  action_fallback IarvisWeb.FallbackController

  def index(conn, %{"id" => category_id} = params) do
    with {:ok, _category} <- get_category(category_id) do
      limit =
        params
        |> Map.get("limit", "10")
        |> parse_pagination_param(10)

      offset =
        params
        |> Map.get("offset", "0")
        |> parse_pagination_param(0)

      posts = Blog.list_posts_by_category_id(category_id, limit: limit, offset: offset)

      total_count = Blog.count_posts_by_category_id(category_id)

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
  end

  defp parse_pagination_param(value, default) do
    case Integer.parse(value) do
      {int, _} when int > 0 -> int
      _ -> default
    end
  end

  defp get_category(id) do
    try do
      {:ok, Blog.get_category!(id)}
    rescue
      Ecto.NoResultsError -> {:error, :not_found}
    end
  end
end
