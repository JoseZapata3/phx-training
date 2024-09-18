defmodule Discuss.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :nickname, :string
    field :provider, :string
    field :token, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:nickname, :provider, :token])
    |> validate_required([:nickname, :provider, :token])
  end

end
