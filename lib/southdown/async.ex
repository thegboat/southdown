defmodule Southdown.Async do
  @moduledoc false
  use Southdown.Common

  def flushall do
    command(["FLUSHALL", "ASYNC"])
  end

  def flushdb do
    command(["FLUSHDB", "ASYNC"])
  end

  def hmset(_key, []), do: :ok

  def hmset(key, pairs) when is_list(pairs) do
    set_in_chunks(["HMSET", key], pairs)
  end

  def hmset(key, map) when is_map(map) do
    hmset(key, map_to_pairs(map))
  end

  def mset([]), do: :ok

  def mset(map) when is_map(map) do
    map
    |> map_to_pairs()
    |> mset()
  end

  def mset(pairs) when is_list(pairs) do
    set_in_chunks(["MSET"], pairs)
  end

  defp set_in_chunks(cmd, pairs) do
    pairs
    |> Stream.chunk_every(chunk_size() * 2)
    |> Enum.each(fn chunk ->
      command(Enum.concat(cmd, chunk))
    end)
  end

  defp command(cmd) do
    :poolboy.transaction(:southdown, &GenServer.cast(&1, {:noreply_command, cmd}))
    :ok
  end
end
