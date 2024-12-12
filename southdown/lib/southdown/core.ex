defmodule Southdown.Core do
  @moduledoc """
  Core module to extend capabilities for interacting with Redis.
  """

  @doc """
  Gets a value from Redis with the given key.
  """
  def get(key) do
    command(["GET", key])
  end

  @doc """
  Gets multiple value provided by keys
  By matching pattern should be used sparingly
  """
  def mget(keys) when is_list(keys) do
    command(["MGET" | keys])
  end

  def mget(pattern) do
    case keys(pattern) do
      {:ok, []} ->
        {:ok, []}

      {:ok, keys} ->
        mget(keys)
    end
  end

  @doc """
  Set multiple values provided by key => value Map
  """
  def mset(map) when is_map(map) do
    "MSET"
    |> prepare_mset_args(map)
    |> command()
  end

  @doc """
  Get a value and set in one atomic operation
  """
  def getset(key, value) do
    command(["GETSET", key, value])
  end

  @doc """
  Gets multiple keys provided by matching pattern
  This should be used sparingly
  """
  def keys(pattern) do
    {:ok, scan(pattern)}
  end

  @doc """
  Gets the value associated with field in the hash stored at key.
  """
  def hget(key, fields) when is_list(fields) do
    hmget(key, fields)
  end

  def hget(key, field) do
    command(["HGET", key, field])
  end

  def hmget(key, fields) do
    ["HMGET", key]
    |> Enum.concat(fields)
    |> command()
  end

  def hget_all(key) do
    ["HGETALL", key]
    |> command()
    |> case do
      {:ok, list} ->
        map =
          list
          |> Enum.chunk_every(2)
          |> Enum.map(fn [a, b] -> {a, b} end)
          |> Map.new()

        {:ok, map}

      error ->
        error
    end
  end

  def hmget_as_map(key, fields) do
    key
    |> hmget(fields)
    |> prepare_mget(fields)
  end

  def hdel(key, field) do
    command(["HDEL", key, field])
  end

  @doc """
  Sets a value in Redis with the given key.
  """
  def set(key, value) do
    command(["SET", key, value])
  end

  @doc """
  Sets a value in Redis with the given key that expires.
  """
  def set(key, value, ttl) do
    command(["SET", key, value, "EX", ttl])
  end

  @doc """
  Sets a value in Redis with the given key if given key does not exist.
  """
  def setnx(key, value) do
    command(["SETNX", key, value])
  end

  def hset(key, map) when is_map(map) do
    hmset(key, map)
  end

  @doc """
  Sets field in the hash stored at key to value.
  """
  def hset(key, field, value) do
    noreply_command(["HSET", key, field, value])
  end

  def hmset(key, map) do
    ["HMSET", key]
    |> prepare_mset_args(map)
    |> noreply_command()
  end

  @doc """
  Sets field in the hash stored at key to value, only if field does not yet exist.
  """
  def hsetnx(key, field, value) do
    command(["HSETNX", key, field, value])
  end

  def lindex(key, index) do
    command(["LINDEX", key, index])
  end

  def lrange(key, start, count) do
    command(["LRANGE", key, start, count])
  end

  def lpush(key, data) do
    push("LPUSH", key, data)
  end

  def rpush(key, data) do
    push("RPUSH", key, data)
  end

  def lpushx(key, data) do
    push("LPUSHX", key, data)
  end

  def rpushx(key, data) do
    push("RPUSHX", key, data)
  end

  @doc """
  Sets a time-to-live on the given key. After the given time has elapsed the key will be deleted.
  """
  def expire(key, ttl) do
    command(["EXPIRE", key, ttl])
  end

  @doc """
  Deletes a key from Redis.
  """
  def delete(key) do
    command(["DEL", key])
  end

  @doc """
  Delete all the keys of all the existing databases.
  """
  def flushall do
    command(["FLUSHALL"])
  end

  @doc """
  Checks if key exists
  """
  def exists(key) do
    case command(["EXISTS", key]) do
      {:ok, 0} -> false
      {:ok, _} -> true
    end
  end

  @doc """
  alias for exists/1
  """
  def exists?(key), do: exists(key)

  @doc """
  Gets multiple values provided by keys
  Returns a Map of key value pairs
  By matching pattern should be used sparingly
  """
  def mget_as_map(keys) do
    keys
    |> mget()
    |> prepare_mget(keys)
  end

  @doc """
  Gets a list from Redis with the given key.
  """
  def get_list(key) do
    command(["LRANGE", key, 0, -1])
  end

  @doc """
  Prepends a value on a list in Redis with the given key.
  """
  def prepend(key, data) do
    lpush(key, data)
  end

  @doc """
  Appends a value on a list in Redis with the given key.
  """
  def append(key, data) do
    rpush(key, data)
  end

  def first(key) do
    lindex(key, 0)
  end

  def last(key) do
    lindex(key, -1)
  end

  @doc """
  Sends a command to Redis.
  """
  def command(command) do
    :poolboy.transaction(:redis_pool, &Redix.command(&1, command))
  end

  @doc """
  Sends a command to Redis.
  """
  def noreply_command(command) do
    :poolboy.transaction(:redis_pool, &Redix.noreply_command(&1, command))
  end

  def multi(commands) do
    :redis_pool
    |> :poolboy.transaction(&Redix.transaction_pipeline(&1, commands))
    |> case do
      {:ok, ["OK" | tl]} ->
        {:ok, List.first(tl)}

      error ->
        error
    end
  end

  def scan(pattern) do
    scan(pattern, [], "0")
  end

  defp push(cmd, key, list) when is_list(list) do
    [cmd, key]
    |> List.flatten(list)
    |> command()
  end

  defp push(cmd, key, val) do
    push(cmd, key, [val])
  end

  defp scan(pattern, prev_data, prev_cursor) do
    case command(["SCAN", String.to_integer(prev_cursor), "MATCH", pattern]) do
      {:ok, [cursor, data]} when cursor != "0" and is_list(data) ->
        scan(pattern, [data | prev_data], cursor)

      _ ->
        List.flatten(prev_data)
    end
  end

  defp prepare_mset_args(comm, map) do
    args =
      map
      |> Enum.map(fn {key, value} ->
        [key, value]
      end)
      |> List.flatten()

    comm
    |> List.wrap()
    |> Enum.concat(args)
  end

  def prepare_mget({:ok, []}, _keys), do: {:ok, %{}}

  def prepare_mget({:ok, list}, keys) do
    map =
      keys
      |> Enum.zip(list)
      |> Enum.into(%{})

    {:ok, map}
  end

  def prepare_mget(other, _keys), do: other
end
