defmodule Iarvis.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :slug, :string
      add :description, :text
      add :parent_id, references(:categories, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:categories, [:slug])
    create unique_index(:categories, [:name])
    create index(:categories, [:parent_id])
  end
end
