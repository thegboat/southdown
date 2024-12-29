defmodule Southdown.Basic do
  @moduledoc false
  use Southdown.Common

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

  def flushall do
    command(["FLUSHALL", "SYNC"])
  end

  def flushdb do
    command(["FLUSHDB", "SYNC"])
  end

  def get(key) do
    command(["GET", key])
  end

  def getall do
    mget("*")
  end

  def getdel(key) do
    command(["GETDEL", key])
  end

  def getex(key, ttl) do
    command(["GET", key, "EX", ttl])
  end

  def getlist(key) do
    lrange(key, 0, -1)
  end

  def getrange(key, start_idx, end_idx) do
    command(["GETRANGE", key, start_idx, end_idx])
  end

  def getset(key, value) do
    command(["GETSET", key, value])
  end

  def hget(key, field) do
    command(["HGET", key, field])
  end

  def hgetall(key) do
    ["HGETALL", key]
    |> command()
    |> format_hgetall()
  end

  def hkeys(key) do
    hkeys(key, "*")
  end

  def hkeys(key, pattern) do
    with {:ok, result} <- auto_scan(0, [], ["HSCAN", key], pattern) do
      no_values = result
      |> Stream.chunk_every(2)
      |> Enum.map(&Enum.at(&1, 0))

      {:ok, no_values}
    end
  end

  def hmget(key, pattern) when is_binary(pattern) do
    with {:ok, result} <- auto_scan(0, [], ["HSCAN", key], pattern) do
      map = result
      |> Stream.chunk_every(2)
      |> Stream.map(fn [k, v] -> {k, v} end)
      |> Enum.into(%{})

      {:ok, map}
    end
  end

  def hmget(key, fields) when is_list(fields) do
    ["HMGET" | [key | fields]]
    |> command()
    |> format_mget(fields)
  end

  def hmset(_key, []), do: {:ok, "OK"}

  def hmset(key, pairs) when is_list(pairs) do
    ["HMSET", key]
    |> Enum.concat(pairs)
    |> command()
  end

  def hmset(key, map) when is_map(map) do
    hmset(key, map_to_pairs(map))
  end

  def hscan(key, cursor, pattern) do
    command(["HSCAN", key, cursor, "MATCH", pattern])
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

  def lpop(key) do
    command(["LPOP", key])
  end

  def lrange(key, start_idx, end_idx) do
    command(["LRANGE", key, start_idx, end_idx])
  end

  def mget(pattern) when is_binary(pattern) do
    with {:ok, keys} <- keys(pattern) do
      keys
      |> Stream.chunk_every(chunk_size())
      |> Enum.reduce_while({:ok, %{}}, fn chunk, {:ok, acc} ->
          case mget(chunk) do
            {:ok, map} -> {:cont, {:ok, Map.merge(acc, map)}}
            error -> {:halt, error}
          end
      end)
    end
  end

  def mget([]), do: {:ok, %{}}

  def mget(keys) when is_list(keys) do
    ["MGET" | keys]
    |> command()
    |> format_mget(keys)
  end

  def mset([]), do: {:ok, "OK"}

  def mset(pairs) when is_list(pairs) do
    command(["MSET" | pairs])
  end

  def mset(map) when is_map(map) do
    map
    |> map_to_pairs()
    |> mset()
  end

  def rpop(key) do
    command(["RPOP", key])
  end

  def scan(cursor, pattern) do
    command(["SCAN", cursor, "MATCH", pattern])
  end

  defp format_hgetall({:ok, data}) do
    map = data
    |> Stream.chunk_every(2)
    |> Enum.reduce(%{}, fn [f, v], acc ->
      Map.put(acc, f, v)
    end)

    {:ok, map}
  end

  defp format_hgetall(other), do: other

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