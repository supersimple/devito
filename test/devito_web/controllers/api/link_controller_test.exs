defmodule DevitoWeb.API.LinkControllerTest do
  use DevitoWeb.ConnCase

  alias Devito.Link

  setup %{conn: conn} do
    System.put_env("AUTH_TOKEN", "abc123")

    test_token =
      :sha256
      |> :crypto.hash("abc123")
      |> Base.encode64()

    on_exit(fn -> System.delete_env("AUTH_TOKEN") end)

    %{conn: conn, test_token: test_token}
  end

  test "GET /", %{conn: conn, test_token: test_token} do
    db = Devito.CubDB.db()

    test_link = %Link{
      short_code: "test",
      url: "https://test.com",
      count: 0,
      created_at: DateTime.utc_now()
    }

    CubDB.put(db, "test", test_link)
    conn = get(conn, "/api/", %{auth_token: test_token})
    assert %{"links" => [asserted_link]} = json_response(conn, 200)
    assert Map.get(asserted_link, "short_code") == "test"
    assert Map.get(asserted_link, "url") == "https://test.com"
    CubDB.delete(db, "test")
  end

  test "GET /short_code", %{conn: conn, test_token: test_token} do
    db = Devito.CubDB.db()

    test_link = %Link{
      short_code: "test",
      url: "https://test.com",
      count: 0,
      created_at: DateTime.utc_now()
    }

    CubDB.put(db, "test", test_link)
    conn = get(conn, "/api/test", %{auth_token: test_token})
    assert asserted_link = json_response(conn, 200)
    assert Map.get(asserted_link, "short_code") == "test"
    assert Map.get(asserted_link, "url") == "https://test.com"
    CubDB.delete(db, "test")
  end

  test "GET /invalid_short_code", %{conn: conn, test_token: test_token} do
    db = Devito.CubDB.db()

    conn = get(conn, "/api/invalidlink", %{auth_token: test_token})
    assert json_response(conn, 404)
    CubDB.delete(db, "test")
  end

  describe "POST /" do
    setup do
      db = Devito.CubDB.db()
      %{db: db}
    end

    test "create with valid params", %{db: db, conn: conn, test_token: test_token} do
      conn =
        post(conn, "/api/link", %{
          "url" => "http://vaild.url",
          "short_code" => "v4l1d",
          "auth_token" => test_token
        })

      assert json_response(conn, 201)
      CubDB.delete(db, "v4l1d")
    end

    test "create with only the url", %{db: db, conn: conn, test_token: test_token} do
      conn = post(conn, "/api/link", %{"url" => "http://vaild.url", "auth_token" => test_token})
      assert resp = json_response(conn, 201)
      assert resp["short_code"]
      CubDB.delete(db, resp["short_code"])
    end
  end
end
