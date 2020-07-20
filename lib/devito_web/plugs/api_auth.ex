defmodule DevitoWeb.Plugs.APIAuth do
  @moduledoc """
  A Plug for authenticating accounts
  """
  import Plug.Conn

  def init(_opts), do: :ok

  def call(conn, _opts \\ []) do
    case valid_token?(conn) do
      true ->
        conn

      _false ->
        conn
        |> resp(401, "unauthorized")
        |> send_resp()
        |> halt()
    end
  end

  def valid_token?(%{params: %{"auth_token" => auth_token}}),
    do: Devito.Auth.valid_token?(auth_token)

  def valid_token?(_conn), do: false
end
