defmodule Devito.Data do
  @moduledoc """
  Manages persistent data.
  """

  use GenServer
  alias Devito.Link

  @table_name Application.fetch_env!(:devito, :table_name)

  def start_link(opts \\ %{}) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    memory_table = :ets.new(@table_name, [:set, :named_table, :public])
    {:ok, disk_table} = init_disk_table()

    {:ok, %{disk_table: disk_table, memory_table: memory_table}, {:continue, :hydrate_table}}
  end

  def handle_continue(:hydrate_table, %{disk_table: disk_table, memory_table: memory_table} = state) do
    hydrate_memory(disk_table, memory_table)
    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state) do
    :dets.close(@table_name)
    {:noreply, state}
  end

  def insert(link) do
    if :ets.insert_new(@table_name, {link.short_code, link.url, DateTime.utc_now(), 0}) do
      :dets.insert_new(@table_name, {link.short_code, link.url, DateTime.utc_now(), 0})
    end
    :ok
  end

  def find(short_code) do
    case :ets.lookup(@table_name, short_code) do
      [] -> nil
      [{short_code, url, created_at, count} | _t] -> %Link{short_code: short_code, url: url, count: count, created_at: created_at}
    end
  end

  def all() do
    @table_name
    |> :ets.tab2list()
    |> Enum.map(fn {short_code, url, created_at, count} -> %Link{url: url, short_code: short_code, created_at: created_at, count: count} end)
  end

  def increment_count(short_code) do
    try do
      :ets.update_counter(@table_name, short_code, {4, 1})
    rescue
      _e -> :error
    end
  end

  defp init_disk_table do
    :dets.open_file(@table_name, [type: :set])
  end

  defp hydrate_memory(disk_table, memory_table) do
    :dets.to_ets(disk_table, memory_table)
  end
end
