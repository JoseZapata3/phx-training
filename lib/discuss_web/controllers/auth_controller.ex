defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.{Repo, User}

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do

    IO.inspect(conn)
    user_params = %{token: auth.credentials.token, nickname: auth.info.nickname, provider: "github"}
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome!")
        |> put_session(:user_id, user.id)
        |> redirect(to: "/")
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error Signin in")
        |> redirect(to: "/")

    end
  end

  defp insert_or_update_user(changeset) do
    case  Repo.get_by(User, nickname: changeset.changes.nickname) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
