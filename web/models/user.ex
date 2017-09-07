defmodule Achieve.User do
  use Achieve.Web, :model

  schema "users" do
    field :uid, :integer
    field :access_token, :string
    field :synced, :utc_datetime

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:access_token, :synced, :uid])
    |> validate_required([:access_token, :uid])
  end
end
