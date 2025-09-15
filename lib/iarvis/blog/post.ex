defmodule Iarvis.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :status, :string
    field :title, :string
    field :slug, :string
    field :content, :string
    field :excerpt, :string
    field :featured_image, :string
    field :author_name, :string
    field :author_email, :string
    field :is_featured, :boolean, default: false
    field :view_count, :integer
    field :published_at, :utc_datetime
    field :category_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :slug, :content, :excerpt, :featured_image, :author_name, :author_email, :status, :is_featured, :view_count, :published_at])
    |> validate_required([:title, :slug, :content, :excerpt, :featured_image, :author_name, :author_email, :status, :is_featured, :view_count, :published_at])
    |> unique_constraint(:slug)
  end
end
