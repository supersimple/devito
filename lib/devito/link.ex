defmodule Devito.Link do
  @moduledoc """
  Schema for a link.
  """

  @enforce_keys [:url, :short_code]
  defstruct [:url, :short_code, :count, :created_at]

  @doc """
  Checks that a link is valid.
  `Valid` means the url is present and the short_code
  is both present and unique.
  """
  @spec valid?(%__MODULE__{}) :: boolean()
  def valid?(%__MODULE__{url: url, short_code: short_code}) do
    valid_uri?(url) and
      valid_short_code?(short_code)
  end

  def generate_short_code() do
    short_code_chars = Application.get_env(:devito, :short_code_chars)

    Enum.reduce(0..5, [], fn _n, acc -> acc ++ Enum.take_random(short_code_chars, 1) end)
    |> List.to_string()
  end

  def insert_link(link) do
    db = Devito.CubDB.db()
    # Verify short code doesnt already exist
    CubDB.put(db, link.short_code, link)
  end

  def find_link(short_code) do
    db = Devito.CubDB.db()
    CubDB.get(db, short_code)
  end

  def increment_count(short_code) do
    db = Devito.CubDB.db()

    CubDB.get_and_update(db, short_code, fn
      nil ->
        {:error, :not_found}

      link ->
        link = %{link | count: link.count + 1}
        {:ok, link}
    end)
  end

  defp valid_uri?(string) do
    parsed = URI.parse(string)

    parsed.host not in [nil, ""] and
      parsed.scheme not in [nil, ""] and
      String.starts_with?(parsed.scheme, "http")
  end

  defp valid_short_code?(string) do
    db = Devito.CubDB.db()

    resp =
      string not in [nil, ""] and
        is_nil(CubDB.get(db, string))

    resp
  end
end
