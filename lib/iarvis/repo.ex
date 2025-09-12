defmodule Iarvis.Repo do
  use Ecto.Repo,
    otp_app: :iarvis,
    adapter: Ecto.Adapters.Postgres
end
