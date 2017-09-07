defmodule Achieve.AuthController do
  use Achieve.Web, :controller
  plug Ueberauth

  def request(conn, _params) do
    text(conn, "You should be redirected")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    text(conn, "Something went wrong.")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case find_or_create(auth) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Logged in")
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  defp find_or_create(auth) do
    case Repo.get_by(Achieve.User, uid: auth.uid) do
      nil -> create(auth)
      user -> {:ok, user}
    end
  end

  defp create(auth) do
    changeset = Achieve.User.changeset(%Achieve.User{}, %{uid: auth.uid, access_token: auth.credentials.token})

    case Repo.insert(changeset) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} ->
        {:error, "Something went wrong inserting you into the database"}
    end
  end
end