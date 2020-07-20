defmodule DevitoWeb.API.LinkControllerTest do
  use DevitoWeb.ConnCase

  alias Devito.Link

  test "GET /", %{conn: conn} do
    db = Devito.CubDB.db()

    test_link = %Link{
      short_code: "test",
      url: "https://test.com",
      count: 0,
      created_at: DateTime.utc_now()
    }

    CubDB.put(db, "test", test_link)
    conn = get(conn, "/api/")
    assert %{"links" => [asserted_link]} = json_response(conn, 200)
    assert Map.get(asserted_link, "short_code") == "test"
    assert Map.get(asserted_link, "url") == "https://test.com"
    CubDB.delete(db, "test")
  end

  test "GET /short_code", %{conn: conn} do
    db = Devito.CubDB.db()

    test_link = %Link{
      short_code: "test",
      url: "https://test.com",
      count: 0,
      created_at: DateTime.utc_now()
    }

    CubDB.put(db, "test", test_link)
    conn = get(conn, "/api/test")
    assert asserted_link = json_response(conn, 200)
    assert Map.get(asserted_link, "short_code") == "test"
    assert Map.get(asserted_link, "url") == "https://test.com"
    CubDB.delete(db, "test")
  end

  test "GET /invalid_short_code", %{conn: conn} do
    db = Devito.CubDB.db()

    conn = get(conn, "/api/invalidlink")
    assert json_response(conn, 404)
    CubDB.delete(db, "test")
  end

  describe "POST /" do
    setup do
      db = Devito.CubDB.db()
      %{db: db}
    end

    test "create with valid params", %{db: db, conn: conn} do
      conn = post(conn, "/api/link", %{"url" => "http://vaild.url", "short_code" => "v4l1d"})
      assert json_response(conn, 201)
      CubDB.delete(db, "v4l1d")
    end

    test "create with only the url", %{db: db, conn: conn} do
      conn = post(conn, "/api/link", %{"url" => "http://vaild.url"})
      assert resp = json_response(conn, 201)
      assert resp["short_code"]
      CubDB.delete(db, resp["short_code"])
    end
  end
end
