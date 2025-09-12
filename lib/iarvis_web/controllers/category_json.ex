defmodule IarvisWeb.CategoryJSON do
  alias Iarvis.Blog.Category

  @doc """
  Renders a list of categories.
  """
  def index(%{categories: categories}) do
    %{categories: for(category <- categories, do: data(category))}
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
