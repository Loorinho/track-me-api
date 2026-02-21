defmodule TrackMeApiWeb.ProjectController do
  use TrackMeApiWeb, :controller

  alias TrackMeApi.Projects
  alias TrackMeApi.Projects.Project

  action_fallback TrackMeApiWeb.FallbackController

  def list_projects(conn, _params) do
    projects = Projects.list_projects()
    render(conn, :index, projects: projects)
  end

  def create_project(conn, %{"project" => project_params}) do
    with {:ok, %Project{} = project} <- Projects.create_project(project_params) do
      conn
      |> put_status(:created)
      |> render(:project_creation_response, project: project)
    end
  end

  def get_project_details(conn, %{"id" => id}) do
    with %Projects.Project{} = project <- Projects.get_project_by_id(id) do
      render(conn, :show, project: project)
    else
      nil ->
        {:error, :not_found}
    end
  end

  # def get_project_details(conn, %{"id" => id}) do

  #   project = Projects.get_project!(id)

  #   IO.inspect(project, label: "Project details")

  #   render(conn, :show, project: project)
  # end

  def update_project(conn, %{"id" => id, "project" => project_params}) do
    project = Projects.get_project!(id)

    with {:ok, %Project{} = project} <- Projects.update_project(project, project_params) do
      render(conn, :show, project: project)
    end
  end

  def delete_project(conn, %{"id" => id}) do
    project = Projects.get_project!(id)

    with {:ok, %Project{}} <- Projects.delete_project(project) do
      send_resp(conn, :no_content, "")
    end
  end
end
