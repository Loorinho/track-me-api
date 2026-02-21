defmodule TrackMeApi.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :status, :string
      add :owner_id, references(:accounts, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:projects, [:owner_id])
    create index(:projects, :id)
  end
end
