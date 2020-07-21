defmodule Devito.Auth do
  @moduledoc false

  @spec valid_token?(String.t()) :: boolean()
  def valid_token?(token) do
    with auth_token <- System.get_env("AUTH_TOKEN"),
         false <- is_nil(auth_token),
         false <- is_nil(token) do
      hash_token(auth_token) == token
    else
      _error -> false
    end
  end

  defp hash_token(token) do
    :sha256
    |> :crypto.hash(token)
    |> Base.encode64()
  end
end
