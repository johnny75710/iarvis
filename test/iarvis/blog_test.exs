defmodule Iarvis.BlogTest do
  use Iarvis.DataCase

  alias Iarvis.Blog

  describe "categories" do
    alias Iarvis.Blog.Category

    import Iarvis.BlogFixtures

    @invalid_attrs %{name: nil, description: nil, slug: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Blog.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Blog.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{name: "some name", description: "some description", slug: "some slug"}

      assert {:ok, %Category{} = category} = Blog.create_category(valid_attrs)
      assert category.name == "some name"
      assert category.description == "some description"
      assert category.slug == "some slug"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        slug: "some updated slug"
      }

      assert {:ok, %Category{} = category} = Blog.update_category(category, update_attrs)
      assert category.name == "some updated name"
      assert category.description == "some updated description"
      assert category.slug == "some updated slug"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_category(category, @invalid_attrs)
      assert category == Blog.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Blog.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Blog.change_category(category)
    end
  end

  describe "posts" do
    alias Iarvis.Blog.Post

    import Iarvis.BlogFixtures

    @invalid_attrs %{status: nil, title: nil, slug: nil, content: nil, excerpt: nil, featured_image: nil, author_name: nil, author_email: nil, is_featured: nil, view_count: nil, published_at: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Blog.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Blog.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{status: "some status", title: "some title", slug: "some slug", content: "some content", excerpt: "some excerpt", featured_image: "some featured_image", author_name: "some author_name", author_email: "some author_email", is_featured: true, view_count: 42, published_at: ~U[2025-09-12 21:33:00Z]}

      assert {:ok, %Post{} = post} = Blog.create_post(valid_attrs)
      assert post.status == "some status"
      assert post.title == "some title"
      assert post.slug == "some slug"
      assert post.content == "some content"
      assert post.excerpt == "some excerpt"
      assert post.featured_image == "some featured_image"
      assert post.author_name == "some author_name"
      assert post.author_email == "some author_email"
      assert post.is_featured == true
      assert post.view_count == 42
      assert post.published_at == ~U[2025-09-12 21:33:00Z]
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{status: "some updated status", title: "some updated title", slug: "some updated slug", content: "some updated content", excerpt: "some updated excerpt", featured_image: "some updated featured_image", author_name: "some updated author_name", author_email: "some updated author_email", is_featured: false, view_count: 43, published_at: ~U[2025-09-13 21:33:00Z]}

      assert {:ok, %Post{} = post} = Blog.update_post(post, update_attrs)
      assert post.status == "some updated status"
      assert post.title == "some updated title"
      assert post.slug == "some updated slug"
      assert post.content == "some updated content"
      assert post.excerpt == "some updated excerpt"
      assert post.featured_image == "some updated featured_image"
      assert post.author_name == "some updated author_name"
      assert post.author_email == "some updated author_email"
      assert post.is_featured == false
      assert post.view_count == 43
      assert post.published_at == ~U[2025-09-13 21:33:00Z]
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end
end
