defmodule Iarvis.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Iarvis.Blog` context.
  """

  @doc """
  Generate a unique category name.
  """
  def unique_category_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique category slug.
  """
  def unique_category_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: unique_category_name(),
        slug: unique_category_slug()
      })
      |> Iarvis.Blog.create_category()

    category
  end
end
