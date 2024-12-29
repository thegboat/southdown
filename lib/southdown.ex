defmodule Southdown do
  @moduledoc """
  A redis client library
  """
  alias Southdown.Async
  alias Southdown.Basic
  alias Southdown.Core
  alias Southdown.Pool

  defdelegate start_link(opts), to: Pool

  defdelegate command(cmd), to: Core
  defdelegate pipeline(cmds), to: Core
  defdelegate noreply_command(cmd), to: Core
  defdelegate noreply_pipeline(cmds), to: Core
  defdelegate transaction_pipeline(cmds), to: Core

  defdelegate exists(key), to: Basic
  defdelegate exists?(key), to: Basic
  defdelegate first(key), to: Basic
  defdelegate get(key), to: Basic
  defdelegate getall, to: Basic
  defdelegate getdel(key), to: Basic
  defdelegate getex(key, ttl), to: Basic
  defdelegate getlist(key), to: Basic
  defdelegate getrange(key, start_idx, end_idx), to: Basic
  defdelegate getset(key, value), to: Basic
  defdelegate hkeys(key), to: Basic
  defdelegate hkeys(key, pattern), to: Basic
  defdelegate hget(key, field), to: Basic
  defdelegate hgetall(key), to: Basic
  defdelegate hmget(key, fields), to: Basic
  defdelegate keys, to: Basic
  defdelegate keys(pattern), to: Basic
  defdelegate last(key), to: Basic
  defdelegate lrange(key, start_idx, end_idx), to: Basic
  defdelegate mget(keys), to: Basic
  defdelegate scan(cursor, pattern), to: Basic

  defdelegate append(key, data), to: Basic
  defdelegate decr(key), to: Basic
  defdelegate decrby(key, by), to: Basic
  defdelegate del(key), to: Basic
  defdelegate expire(key, ttl), to: Basic
  defdelegate flushall, to: Basic
  defdelegate flushdb, to: Basic
  defdelegate hdel(key, field), to: Basic
  defdelegate hmset(key, map_or_pairs), to: Basic
  defdelegate hscan(key, cursor, pattern), to: Basic
  defdelegate hset(key, field, value), to: Basic
  defdelegate hsetnx(key, field, value), to: Basic
  defdelegate incr(key), to: Basic
  defdelegate incrby(key, by), to: Basic
  defdelegate lindex(key, idx), to: Basic, as: :lindex
  defdelegate llen(key), to: Basic, as: :llen
  defdelegate lpop(key), to: Basic, as: :lpop
  defdelegate lpush(key, data), to: Basic
  defdelegate lpushx(key, data), to: Basic
  defdelegate lset(key, index, value), to: Basic
  defdelegate mset(map_or_pairs), to: Basic
  defdelegate prepend(key, list), to: Basic
  defdelegate rpop(key), to: Basic, as: :rpop
  defdelegate rpush(key, data), to: Basic
  defdelegate rpushx(key, data), to: Basic
  defdelegate set(key, value), to: Basic
  defdelegate set(key, value, ttl), to: Basic
  defdelegate setex(key, value, ttl), to: Basic
  defdelegate setnx(key, value), to: Basic
  
  defdelegate async_append(key, data), to: Async, as: :append
  defdelegate async_decr(key), to: Async, as: :decr
  defdelegate async_decrby(key, by), to: Async, as: :decrby
  defdelegate async_del(key), to: Async, as: :del
  defdelegate async_expire(key, ttl), to: Async, as: :expire
  defdelegate async_flushall, to: Async, as: :flushall
  defdelegate async_flushdb, to: Async, as: :flushdb
  defdelegate async_hdel(key, field), to: Async, as: :hdel
  defdelegate async_hmset(key, map_or_pairs), to: Async, as: :hmset
  defdelegate async_hset(key, field, value), to: Async, as: :hset
  defdelegate async_hsetnx(key, field, value), to: Async, as: :hsetnx
  defdelegate async_incr(key), to: Async, as: :incr
  defdelegate async_incrby(key, by), to: Async, as: :incrby
  defdelegate async_lpush(key, data), to: Async, as: :lpush
  defdelegate async_lpushx(key, data), to: Async, as: :lpushx
  defdelegate async_lset(key, index, value), to: Async, as: :lset
  defdelegate async_mset(map_or_pairs), to: Async, as: :mset
  defdelegate async_prepend(key, list), to: Async, as: :prepend
  defdelegate async_rpush(key, data), to: Async, as: :rpush
  defdelegate async_rpushx(key, data), to: Async, as: :rpushx
  defdelegate async_set(key, value), to: Async, as: :set
  defdelegate async_set(key, value, ttl), to: Async, as: :set
  defdelegate async_setex(key, value, ttl), to: Async, as: :setex
  defdelegate async_setnx(key, value), to: Async, as: :setnx
end
