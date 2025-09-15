defmodule MyApp.Repo.Migrations.CreatePostTags do
  use Ecto.Migration

  def change do
    create table(:post_tags, primary_key: false) do
      add :post_id, references(:posts, type: :binary_id, on_delete: :delete_all), null: false
      add :tag_id, references(:tags, type: :binary_id, on_delete: :delete_all), null: false
    end

    create unique_index(:post_tags, [:post_id, :tag_id])
    create index(:post_tags, [:post_id])
    create index(:post_tags, [:tag_id])
  end
end
