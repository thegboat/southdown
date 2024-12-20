defmodule Southdown.Basic do
  @moduledoc false
  use Southdown.Modify

  alias Southdown.Core

  def exists(key) do
    command(["EXISTS", key])
  end

  def exists?(key) do
    case exists(key) do
      {:ok, 1} -> true
      {:ok, 0} -> false
      {:error, %{reason: reason}} ->
        raise "A Redix Error occured: #{reason}"
      {:error, %{message: message}} ->
        raise "A Redix Error occured: #{message}"
    end
  end

  def first(key) do
    lindex(key, 0)
  end

  def flush_all do
    command(["FLUSHALL", "SYNC"])
  end

  def flush_db do
    command(["FLUSHDB", "SYNC"])
  end

  def get(key) do
    command(["GET", key])
  end

  def getdel(key) do
    command(["GETDEL", key])
  end

  def getex(key, ttl) do
    command(["GET", key, "EX", ttl])
  end

  def getrange(key, start_idx, end_idx) do
    command(["GETRANGE", key, start_idx, end_idx])
  end

  def getset(key, value) do
    command(["GETSET", key, value])
  end

  def hkeys(key) do
    hkeys(key, "*")
  end

  def hkeys(key, pattern) do
    auto_scan(0, [], ["HSCAN", key], pattern)
  end

  def hget(key, field) do
    command(["HGET", key, field])
  end

  def hget_all(key) do
    command(["HGETALL", key])
  end

  def hget_all_as_map(key) do
    key
    |> hget_all()
    |> format_mget()
  end

  def hmget(key, fields) when is_list(fields) do
    ["HMGET", key]
    |> Enum.concat(fields)
    |> command()
  end
  
  def hmget_as_map(key, fields) do
    key
    |> hmget(fields)
    |> format_mget(fields)
  end

  def keys do
    keys("*")
  end

  def keys(pattern) do
    auto_scan(0, [], ["SCAN"], pattern)
  end

  def last(key) do
    lindex(key, -1)
  end

  def lindex(key, index) do
    command(["LINDEX", key, index])
  end

  def llen(key) do
    command(["LLEN", key])
  end

  def mget(keys) when is_list(keys) do
    command(["MGET" | keys])
  end

  def mget_as_map(keys) do
    keys
    |> mget()
    |> format_mget(keys)
  end

  def scan(cursor, pattern) do
    command(["SCAN", cursor, "MATCH #{pattern}"])
  end

  defp format_mget({:ok, data}) do
    {fields, values} = data
    |> Stream.chunk_every(2)
    |> Enum.reduce({[], []}, fn [f, v], {fs, vs} ->
      {[f | fs], [v | vs]}
    end)

    format_mget({:ok, values}, fields)
  end

  defp format_mget(other), do: other

  defp format_mget({:ok, []}, _keys), do: {:ok, %{}}

  defp format_mget({:ok, list}, keys) do
    map =
      keys
      |> Stream.zip(list)
      |> Enum.into(%{})

    {:ok, map}
  end

  defp format_mget(other, _keys), do: other

  defp auto_scan("0", data, _cmd, _pattern) do
    {:ok, Enum.uniq(data)}
  end

  defp auto_scan(cursor, prev_data, cmd, pattern) do
    cmd
    |> Enum.concat([to_int(cursor), "MATCH", pattern])
    |> command()
    |> case do
      {:error, _} = error -> 
        error
      {:ok, [cursor, data]} -> 
        data = Enum.concat(prev_data, data)
        auto_scan(cursor, Enum.concat(prev_data, data), cmd, pattern)
    end
  end

  defp to_int(int) when is_integer(int), do: int
  defp to_int(int) when is_binary(int) do
    String.to_integer(int)
  end

  defp command(cmd) do
    Core.command(cmd)
  end
end