defmodule Iarvis.Blog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "categories" do
    field :name, :string
    field :description, :string
    field :slug, :string
    field :parent_id, :binary_id

    has_many :posts, Iarvis.Blog.Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :slug, :description])
    |> validate_required([:name, :slug, :description])
    |> unique_constraint(:slug)
    |> unique_constraint(:name)
  end
end
