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

  @doc """
  Generate a unique post slug.
  """
  def unique_post_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        author_email: "some author_email",
        author_name: "some author_name",
        content: "some content",
        excerpt: "some excerpt",
        featured_image: "some featured_image",
        is_featured: true,
        published_at: ~U[2025-09-12 21:33:00Z],
        slug: unique_post_slug(),
        status: "some status",
        title: "some title",
        view_count: 42
      })
      |> Iarvis.Blog.create_post()

    post
  end
end
