defmodule Achieve.InitController do
  use Achieve.Web, :controller
  use Guardian.Phoenix.Controller
  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.LoadResource

  def index(conn, _params, nil, _), do: redirect(conn, to: "/auth/github")
  def index(conn, _params, user, claims) do
    #repos = Tentacat.Repositories.list_orgs("IOOPM-UU", %Tentacat.Client{auth: %{access_token: user.access_token}})
    repos = Tentacat.Repositories.list_mine(%Tentacat.Client{auth: %{access_token: user.access_token}})
    conn
    |> render("index.html", repos: repos)
  end
  
  def new(conn, _params, nil, _), do: redirect(conn, to: "/")
  def new(conn, _params, user, claims) do  
    name = "achievements"
    {201, repo} = Tentacat.Repositories.create(name, %Tentacat.Client{auth: %{access_token: user.access_token}})
  
    username = Map.fetch!(Map.fetch!(repo, "owner"), "login")

    spawn(__MODULE__, :create_issues, [user.access_token, username, name])

    html(conn, "Det här kommer troligen ta en liten stund,
                så kolla på GitHub när det är färdigt :)<br>
                Du kan hitta repot på <a href='" <> username <> "/" <> name <> "'>här</a>") 
  end

  def run(conn, _params, nil, _), do: redirect(conn, to: "/")
  def run(conn, %{"id" => id, "owner" => owner}, user, claims) do
    spawn(create_issues(user.access_token, owner, id))
    
    conn
    |> text("Servern jobbar på att sätta in alla achievements, var god vänta. Denna sida kommer inte att uppdatera automatiskt")
  end

  def create_issues(token, owner, id) do
    for file <- File.ls!("web/achievements/") do
      {:ok, issue} = File.read("web/achievements/" <> file)
      "# " <> header = hd(String.split(issue, "\n"))
      ach = hd(String.split(file, "."))

      Tentacat.Issues.create(
        owner,
        id,
        %{
          "title" => ach <> " - " <> header,
          "body" => issue
        },
        %Tentacat.Client{auth: %{access_token: token}}
      )

      :timer.sleep(5000)
    end

    {:ok}
  end
end