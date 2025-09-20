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

    belongs_to :category, Iarvis.Blog.Category

    timestamps(type: :utc_datetime)
  end

  @required_attrs [
    :title,
    :slug,
    :content,
    :excerpt,
    :featured_image,
    :author_name,
    :author_email,
    :status,
    :is_featured,
    :view_count,
    :published_at
  ]

  @optional_attrs [
    :category_id
  ]

  @all_attrs @required_attrs ++ @optional_attrs

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, @all_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:slug)
    |> foreign_key_constraint(:category_id)
  end
end
