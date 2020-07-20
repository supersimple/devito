defmodule DevitoWeb.Plugs.APIAuth do
  @moduledoc """
  A Plug for authenticating accounts
  """
  import Plug.Conn

  def init(_opts), do: :ok

  def call(conn, _opts \\ []) do
    case auth_user(conn) do
      :ok ->
        conn

      _error ->
        conn
        |> resp(401, "unauthorized")
        |> send_resp()
        |> halt()
    end
  end

  def auth_user(conn) do
    :ok
  end
end
