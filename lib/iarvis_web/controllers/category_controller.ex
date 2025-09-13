defmodule IarvisWeb.CategoryController do
  use IarvisWeb, :controller

  alias Iarvis.Blog
  alias Iarvis.Blog.Category

  action_fallback IarvisWeb.FallbackController

  def index(conn, params) do
    limit =
      params
      |> Map.get("limit", "100")
      |> parse_pagination_param(100)

    offset =
      params
      |> Map.get("offset", "0")
      |> parse_pagination_param(0)

    categories = Blog.list_categories(limit: limit, offset: offset)

    total_count = Blog.count_categories()

    has_more = offset + limit < total_count

    last_element = List.last(categories)

    pagination = %{
      limit: limit,
      offset: offset,
      total_count: total_count,
      has_more: has_more,
      last_id: if(last_element, do: last_element.id, else: nil)
    }

    render(conn, :index, categories: categories, pagination: pagination)
  end

  def create(conn, %{"category" => category_params}) do
    with {:ok, %Category{} = category} <- Blog.create_category(category_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/categories/#{category.id}")
      |> render(:show, category: category)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Blog.get_category!(id)
    render(conn, :show, category: category)
  end

  defp parse_pagination_param(value, default) do
    case Integer.parse(value) do
      {int, _} when int > 0 -> int
      _ -> default
    end
  end
end
