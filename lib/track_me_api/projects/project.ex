defmodule TrackMeApi.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  # @project_statuses ["active", "closed", "paused"]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "projects" do
    field :name, :string
    field :description, :string
    field :status, Ecto.Enum, values: [:active, :completed, :paused, :closed], default: :active
    field :owner_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :description, :owner_id])
    |> validate_required([:name], message: "Project name is required")
    |> validate_required([:description], message: "Project description is required")
    |> validate_required([:owner_id], message: "Project owner is required")
    |> validate_length(:name, min: 5, message: "Project name must be at least 5 characters")
    |> validate_length(:description,
      max: 200,
      message: "Project description must be less than 200 characters"
    )
  end
end
