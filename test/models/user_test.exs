defmodule Achieve.UserTest do
  use Achieve.ModelCase

  alias Achieve.User

  @valid_attrs %{access_token: "some content", synced: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
