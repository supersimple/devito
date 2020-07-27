defmodule Devito.CubDB do
  @moduledoc """
  Manages the state of the CubDB instance.
  """

  use GenServer

  @data_location Application.get_env(:devito, :cub_db_file, "priv/data")
  @doc false
  def start_link(opts \\ %{}) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc false
  @impl true
  def init(_opts) do
    {:ok, db} = CubDB.start_link(@data_location)
    {:ok, %{db: db}}
  end

  @doc false
  @impl true
  def handle_call(:db, _from, state) do
    {:reply, state, state}
  end

  def db do
    __MODULE__
    |> GenServer.call(:db)
    |> Map.get(:db)
  end
end
