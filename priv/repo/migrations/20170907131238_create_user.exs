defmodule Achieve.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uid, :integer
      add :access_token, :string
      add :synced, :utc_datetime

      timestamps()
    end

    create index(:users, :access_token)
    create index(:users, :synced)
    create index(:users, :uid)
  end
end
