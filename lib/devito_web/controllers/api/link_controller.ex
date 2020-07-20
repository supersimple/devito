defmodule DevitoWeb.API.LinkController do
  use DevitoWeb, :controller
  alias Devito.Link

  def index(conn, _params) do
    {:ok, links} = Link.all()
    render(conn, "index.json", links: links)
  end

  def show(conn, %{"id" => id}) do
    case Link.find_link(id) do
      nil ->
        conn
        |> put_status(404)
        |> put_layout(false)
        |> put_view(DevitoWeb.ErrorView)
        |> render(:"404", conn.assigns)
        |> halt()

      link ->
        render(conn, "show.json", link: link)
    end
  end

  def create(conn, %{"url" => url, "short_code" => short_code}) do
    link = %Link{
      url: url,
      short_code: short_code,
      count: 0,
      created_at: DateTime.utc_now()
    }

    do_create_link(conn, link)
  end

  def create(conn, %{"url" => url}) do
    link = %Link{
      url: url,
      short_code: Link.generate_short_code(),
      count: 0,
      created_at: DateTime.utc_now()
    }

    do_create_link(conn, link)
  end

  def create(conn, _params) do
    conn
    |> put_status(400)
    |> put_layout(false)
    |> put_view(DevitoWeb.ErrorView)
    |> render(:"400", conn.assigns)
    |> halt()
  end

  defp do_create_link(conn, link) do
    case Link.insert_link(link) do
      :error ->
        conn
        |> put_status(400)
        |> put_layout(false)
        |> put_view(DevitoWeb.ErrorView)
        |> render(:"400", conn.assigns)
        |> halt()

      :ok ->
        conn
        |> put_status(201)
        |> render("show.json", link: link)
    end
  end
end
