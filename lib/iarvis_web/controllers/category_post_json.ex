defmodule IarvisWeb.CategoryPostJSON do
  alias Iarvis.Blog.Post

  @doc """
  Renders a list of posts for a category.
  """
  def index(%{posts: posts, pagination: pagination}) do
    %{
      posts: for(post <- posts, do: data(post)),
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

  defp data(%Post{} = post) do
    %{
      id: post.id,
      title: post.title,
      slug: post.slug,
      content: post.content,
      excerpt: post.excerpt,
      featured_image: post.featured_image,
      author_name: post.author_name,
      author_email: post.author_email,
      status: post.status,
      is_featured: post.is_featured,
      view_count: post.view_count,
      published_at: post.published_at,
      category_id: post.category_id
    }
  end
end
