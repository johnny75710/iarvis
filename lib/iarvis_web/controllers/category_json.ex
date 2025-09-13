defmodule IarvisWeb.CategoryJSON do
  alias Iarvis.Blog.Category

  @doc """
  Renders a list of categories.
  """
  def index(%{categories: categories, pagination: pagination}) do
    %{
      data: for(category <- categories, do: data(category)),
      meta: %{
        pagination: %{
          limit: pagination.limit,
          offset: pagination.offset,
          total_count: pagination.total_count,
          has_more: pagination.has_more,
          last_id: pagination.last_id
        }
      }
    }
  end

  @doc """
  Renders a single category.
  """
  def show(%{category: category}) do
    %{category: data(category)}
  end

  defp data(%Category{} = category) do
    %{
      id: category.id,
      name: category.name,
      slug: category.slug,
      description: category.description
    }
  end
end
