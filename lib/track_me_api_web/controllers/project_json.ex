defmodule TrackMeApiWeb.ProjectJSON do
  # alias TrackMeApi.Helpers
  alias TrackMeApi.Projects.Project

  @doc """
  Renders a list of projects.
  """
  def index(%{projects: projects}) do
    %{
      data: for(project <- projects, do: data(project)),
      success: true,
      message: "Projects retrieved successfully"
    }
  end

  @doc """
  Renders a single project.
  """
  def show(%{project: project}) do
    %{data: data(project), message: "Project details retrieved successfully", success: true}
  end

  @doc """
  Renders a response after successful creation of a project.
  """
  def project_creation_response(%{project: project}) do
    %{data: data(project), message: "Project created successfully", success: true}
  end

  defp data(%Project{} = project) do
    %{
      id: project.id,
      name: project.name,
      description: project.description,
      status: project.status,
      # created_at: Helpers.to_local_date(project.inserted_at)
      created_at: project.inserted_at
    }
  end
end
