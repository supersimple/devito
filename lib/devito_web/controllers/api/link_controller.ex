defmodule DevitoWeb.API.LinkController do
  use DevitoWeb, :controller
  alias Devito.Link

  def index(conn, params) do
    links = Link.all()

    if Map.get(params, "download") do
      data = prepare_json(links)

      conn
      |> put_resp_content_type("application/json")
      |> put_resp_header("content-disposition", "attachment; filename=\"links.json\"")
      |> send_resp(200, data)
    else
      render(conn, "index.json", links: links)
    end
  end

  def show(conn, %{"id" => id}) do
    case Link.find_link(id) do
      nil ->
        render_error(conn, 404)

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
    render_error(conn, 400)
  end

  def import(conn, %{"data" => data}) do
    Enum.each(data, fn %{
                         "url" => url,
                         "short_code" => short_code,
                         "count" => count,
                         "created_at" => created_at
                       } ->
      link = %Link{
        url: url,
        short_code: short_code,
        count: count,
        created_at: created_at
      }

      Link.insert_link(link)
    end)

    conn
    |> put_status(201)
    |> render("show.json", resp: [])
  end

  defp do_create_link(conn, link) do
    case Link.insert_link(link) do
      :error ->
        render_error(conn, 400)

      :ok ->
        conn
        |> put_status(201)
        |> render("show.json", link: link)
    end
  end

  defp prepare_json([]), do: []

  defp prepare_json(links) do
    links
    |> Enum.map(fn link ->
      %{
        count: link.count,
        url: link.url,
        short_code: link.short_code,
        created_at: "#{link.created_at}"
      }
    end)
    |> Jason.encode!()
  end

  defp render_error(conn, status) do
    conn
    |> put_status(status)
    |> put_layout(false)
    |> put_view(DevitoWeb.ErrorView)
    |> render(:"#{status}", conn.assigns)
    |> halt()
  end
end
