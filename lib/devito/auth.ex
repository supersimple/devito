defmodule Devito.Auth do
  @moduledoc false

  @spec valid_token?(String.t()) :: boolean()
  def valid_token?(token) do
    with auth_token <- System.get_env("AUTH_TOKEN"),
         false <- is_nil(auth_token),
         false <- is_nil(token) do
      auth_token == token
    else
      _error -> false
    end
  end
end
