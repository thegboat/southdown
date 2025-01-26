defmodule Southdown.Term do
  @moduledoc false
  import Southdown.Utils, only: [map_to_pairs: 1]
  alias Southdown.Async
  alias Southdown.Basic

  def get(key) do
    with {:ok, binary} <- Basic.get(key) do
      load(binary)
    end
  end

  def hget(key, field) do
    with {:ok, binary} <- Basic.hget(key, field) do
      load(binary)
    end
  end

  def mget(any) do
    with {:ok, map} <- Basic.mget(any) do
      load_from_map(map)
    end
  end

  def hmget(key, any) do
    with {:ok, map} <- Basic.hmget(key, any) do
      load_from_map(map)
    end
  end

  def set(key, term) do
    Basic.set(key, dump(term))
  end

  def hset(key, field, term) do
    Basic.hset(key, field, dump(term))
  end

  def mset(any) do
    do_mset(any, Basic)
  end

  def hmset(key, any) do
    do_hmset(key, any, Basic)
  end

  def async_set(key, term) do
    Async.set(key, dump(term))
  end

  def async_hset(key, field, term) do
    Async.hset(key, field, dump(term))
  end

  def async_mset(any) do
    do_mset(any, Async)
  end

  def async_hmset(key, any) do
    do_hmset(key, any, Async)
  end

  defp do_hmset(key, pairs, module) when is_list(pairs) do
    module.hmset(key, dump_into_pairs(pairs))
  end

  defp do_hmset(key, map, module) when is_map(map) do
    do_hmset(key, map_to_pairs(map), module)
  end

  defp do_mset(pairs, module) when is_list(pairs) do
    pairs
    |> dump_into_pairs()
    |> module.mset()
  end

  defp do_mset(map, module) when is_map(map) do
    map
    |> map_to_pairs()
    |> do_mset(module)
  end

  defp load(binary) do
    term = :erlang.binary_to_term(binary)
    {:ok, term}
  rescue
    e in ArgumentError -> {:error, e.message}
  end

  defp dump(term) do
    :erlang.term_to_binary(term)
  end

  defp load_from_map(map) do
    Enum.reduce_while(map, {:ok, %{}}, fn {key, binary}, {:ok, acc} ->
      case load(binary) do
        {:ok, term} -> {:cont, {:ok, Map.put(acc, key, term)}}
        error -> {:halt, error}
      end
    end)
  end

  defp dump_into_pairs(pairs) do
    pairs
    |> Stream.chunk_every(2)
    |> Enum.flat_map(fn [key, term] ->
      [key, dump(term)]
    end)
  end
end
