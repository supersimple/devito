defmodule DevitoWeb.PageController do
  use DevitoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
