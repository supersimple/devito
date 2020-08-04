defmodule Devito.Repo do
  use Ecto.Repo,
    otp_app: :devito,
    adapter: Ecto.Adapters.Postgres
end
