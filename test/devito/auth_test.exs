defmodule Devito.AuthTest do
  use ExUnit.Case

  alias Devito.Auth

  describe "valid_token?/1" do
    setup do
      System.put_env("AUTH_TOKEN", "abc123")

      on_exit(fn -> System.delete_env("AUTH_TOKEN") end)
    end

    test "when given a valid token" do
      test_token =
        :sha256
        |> :crypto.hash("abc123")
        |> Base.encode64()

      assert Auth.valid_token?(test_token)
    end

    test "when given an invalid token" do
      test_token =
        :sha256
        |> :crypto.hash("badtoken")
        |> Base.encode64()

      refute Auth.valid_token?(test_token)
    end
  end
end
