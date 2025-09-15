defmodule Iarvis.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :slug, :string
      add :content, :text
      add :excerpt, :text
      add :featured_image, :string
      add :author_name, :string
      add :author_email, :string
      add :status, :string
      add :is_featured, :boolean, default: false, null: false
      add :view_count, :integer
      add :published_at, :utc_datetime
      add :category_id, references(:categories, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:posts, [:slug])
    create index(:posts, [:category_id])
  end
end
