defmodule DevitoWeb.LinkController do
  use DevitoWeb, :controller
  alias Devito.Link

  def show(conn, %{"short_code" => short_code}) do
    case Link.find_link(short_code) do
      nil ->
        conn
        |> put_status(404)
        |> put_layout(false)
        |> put_view(DevitoWeb.ErrorView)
        |> render(:"404", conn.assigns)
        |> halt()

      %Link{url: url} ->
        Task.start(fn -> Link.increment_count(short_code) end)

        conn
        |> put_status(301)
        |> redirect(external: url)
    end
  end
end
