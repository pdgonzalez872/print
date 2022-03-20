defmodule Print.Repo do
  use Ecto.Repo,
    otp_app: :print,
    adapter: Ecto.Adapters.Postgres
end
