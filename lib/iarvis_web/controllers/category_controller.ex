defmodule IarvisWeb.CategoryController do
  use IarvisWeb, :controller

  alias Iarvis.Blog
  alias Iarvis.Blog.Category

  action_fallback IarvisWeb.FallbackController

  def index(conn, _params) do
    categories = Blog.list_categories()
    render(conn, :index, categories: categories)
  end

  def create(conn, %{"category" => category_params}) do
    with {:ok, %Category{} = category} <- Blog.create_category(category_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/category/#{category}")
      |> render(:show, category: category)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Blog.get_category!(id)
    render(conn, :show, category: category)
  end

end
