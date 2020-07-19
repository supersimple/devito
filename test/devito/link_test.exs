defmodule Devito.LinkTest do
  use ExUnit.Case

  alias Devito.Link

  describe "valid?/1" do
    test "when given a valid link" do
      assert Link.valid?(%Link{
               url: "https://supersimple.org",
               short_code: "srpsmpl",
               count: 0,
               created_at: DateTime.utc_now()
             })
    end

    test "when given a url that doesnt look like a URI" do
      refute Link.valid?(%Link{
               url: "no-really-a-url",
               short_code: "notrly",
               count: 0,
               created_at: DateTime.utc_now()
             })
    end
  end

  describe "generate_short_code/0" do
    test "creates a 6 character short code" do
      short_code = Link.generate_short_code()
      assert String.length(short_code) == 6
    end
  end
end
