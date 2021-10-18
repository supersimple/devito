defmodule DevitoWeb.API.LinkControllerTest do
  use DevitoWeb.ConnCase

  alias Devito.Link

  @table_name Application.fetch_env!(:devito, :table_name)

  setup %{conn: conn} do
    System.put_env("AUTH_TOKEN", "abc123")

    test_token =
      :sha256
      |> :crypto.hash("abc123")
      |> Base.encode64()

    on_exit(fn ->
      System.delete_env("AUTH_TOKEN")
    end)

    %{conn: conn, test_token: test_token}
  end

  test "GET /", %{conn: conn, test_token: test_token} do
    test_link = %Link{
      short_code: "test",
      url: "https://test.com",
      count: 0,
      created_at: DateTime.utc_now()
    }

    :ets.insert_new(@table_name, {test_link.short_code, test_link.url, test_link.created_at, test_link.count})

    conn = get(conn, "/api/", %{auth_token: test_token})
    assert %{"links" => links} = json_response(conn, 200)
    assert Enum.any?(links, fn asserted_link ->
      Map.get(asserted_link, "short_code") == "test" && Map.get(asserted_link, "url") == "https://test.com"
    end)
  end

  test "GET /short_code", %{conn: conn, test_token: test_token} do
    test_link = %Link{
      short_code: "test",
      url: "https://test.com",
      count: 0,
      created_at: DateTime.utc_now()
    }

    :ets.insert_new(@table_name, {test_link.short_code, test_link.url, test_link.created_at, test_link.count})
    conn = get(conn, "/api/test", %{auth_token: test_token})
    assert asserted_link = json_response(conn, 200)
    assert Map.get(asserted_link, "short_code") == "test"
    assert Map.get(asserted_link, "url") == "https://test.com"
  end

  test "GET /invalid_short_code", %{conn: conn, test_token: test_token} do
    conn = get(conn, "/api/invalidlink", %{auth_token: test_token})
    assert json_response(conn, 404)
  end

  describe "POST /" do
    test "create with valid params", %{conn: conn, test_token: test_token} do
      conn =
        post(conn, "/api/link", %{
          "url" => "http://vaild.url",
          "short_code" => Enum.take_random(?a..?z, 6) |> to_string(),
          "auth_token" => test_token
        })

      assert json_response(conn, 201)
    end

    test "create with only the url", %{conn: conn, test_token: test_token} do
      conn = post(conn, "/api/link", %{"url" => "http://vaild.url", "auth_token" => test_token})
      assert resp = json_response(conn, 201)
      assert resp["short_code"]
    end
  end
end
