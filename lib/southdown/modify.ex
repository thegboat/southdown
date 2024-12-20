defmodule Southdown.Modify do
  @moduledoc false

  defmacro __using__(_opts) do
    quote location: :keep do
      def append(key, data) do
        rpush(key, data)
      end

      def decr(key) do
        decrby(key, 1)
      end

      def decrby(key, by) do
        command(["DECRBY", key, by])
      end

      def del(key) do
        command(["DEL", key])
      end

      def expire(key, ttl) do
        command(["EXPIRE", key, ttl])
      end

      def hdel(key, field) do
        command(["HDEL", key, field])
      end

      def hmset(key, pairs) when is_list(pairs) do
        ["HMSET", key]
        |> Enum.concat(pairs)
        |> command()
      end

      def hmset(key, map) when is_map(map) do
        pairs = map_to_pairs(map)
        hmset(key, pairs)
      end

      def hset(key, field, value) do
        command(["HSET", key, field, value])
      end

      def hsetnx(key, field, value) do
        command(["HSETNX", key, field, value])
      end

      def incr(key) do
        incrby(key, 1)
      end

      def incrby(key, by) do
        command(["INCRBY", key, by])
      end

      def lpop(key) do
        command(["LPOP", key])
      end

      def lpush(key, data) do
        push("LPUSH", key, data)
      end

      def lpushx(key, data) do
        push("LPUSHX", key, data)
      end

      def lset(key, index, value) do
        command(["LSET", key, index, value])
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

      def prepend(key, data) do
        lpush(key, data)
      end

      def rpop(key) do
        command(["RPOP", key])
      end

      def rpush(key, data) do
        push("RPUSH", key, data)
      end

      def rpushx(key, data) do
        push("RPUSHX", key, data)
      end

      def set(key, value) do
        command(["SET", key, value])
      end

      def set(key, value, ttl) do
        command(["SET", key, value, "EX", ttl])
      end

      def setex(key, value, ttl) do
        command(["SET", key, value, "EX", ttl])
      end

      def setnx(key, value) do
        command(["SETNX", key, value])
      end

      defp push(cmd, key, []), do: {:ok, "OK"}

      defp push(cmd, key, list) do
        command([cmd | [key| List.wrap(list)]])
      end

      defp map_to_pairs(map) do
        Enum.flat_map(map, fn {key, value} ->
          [key, value]
        end)
      end

      defp command(_cmd) do
        raise "`command/1` function must be implemented."
      end

      defp command(cmd) do
        Southdown.Core.command(cmd)
      end

      defoverridable command: 1
    end
  end
end
