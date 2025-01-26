defmodule Southdown do
  @moduledoc """
  A redis client library
  """
  alias Southdown.Async
  alias Southdown.Basic
  alias Southdown.Core
  alias Southdown.Pool
  alias Southdown.Term

  @doc delegate_to: {Pool, :start_link, 1}
  defdelegate start_link(opts), to: Pool

  @doc delegate_to: {Core, :command, 1}
  defdelegate command(cmd), to: Core
  @doc delegate_to: {Core, :pipeline, 1}
  defdelegate pipeline(cmds), to: Core
  @doc delegate_to: {Core, :noreply_command, 1}
  defdelegate noreply_command(cmd), to: Core
  @doc delegate_to: {Core, :noreply_pipeline, 1}
  defdelegate noreply_pipeline(cmds), to: Core
  @doc delegate_to: {Core, :transaction_pipeline, 1}
  defdelegate transaction_pipeline(cmds), to: Core

  @doc delegate_to: {Basic, :exists, 1}
  defdelegate exists(key), to: Basic
  @doc delegate_to: {Basic, :exists?, 1}
  defdelegate exists?(key), to: Basic
  @doc delegate_to: {Basic, :first, 1}
  defdelegate first(key), to: Basic
  @doc delegate_to: {Basic, :get, 1}
  defdelegate get(key), to: Basic
  @doc delegate_to: {Basic, :getall, 0}
  defdelegate getall, to: Basic
  @doc delegate_to: {Basic, :getdel, 1}
  defdelegate getdel(key), to: Basic
  @doc delegate_to: {Basic, :getex, 2}
  defdelegate getex(key, ttl), to: Basic
  @doc delegate_to: {Basic, :getlist, 1}
  defdelegate getlist(key), to: Basic
  @doc delegate_to: {Basic, :getrange, 3}
  defdelegate getrange(key, start_idx, end_idx), to: Basic
  @doc delegate_to: {Basic, :getset, 2}
  defdelegate getset(key, value), to: Basic
  @doc delegate_to: {Basic, :hkeys, 1}
  defdelegate hkeys(key), to: Basic
  @doc delegate_to: {Basic, :hkeys, 2}
  defdelegate hkeys(key, pattern), to: Basic
  @doc delegate_to: {Basic, :hget, 2}
  defdelegate hget(key, field), to: Basic
  @doc delegate_to: {Basic, :hgetall, 1}
  defdelegate hgetall(key), to: Basic
  @doc delegate_to: {Basic, :hmget, 2}
  defdelegate hmget(key, fields), to: Basic
  @doc delegate_to: {Basic, :keys, 0}
  defdelegate keys, to: Basic
  @doc delegate_to: {Basic, :keys, 1}
  defdelegate keys(pattern), to: Basic
  @doc delegate_to: {Basic, :last, 1}
  defdelegate last(key), to: Basic
  @doc delegate_to: {Basic, :lrange, 3}
  defdelegate lrange(key, start_idx, end_idx), to: Basic
  @doc delegate_to: {Basic, :mget, 1}
  defdelegate mget(keys), to: Basic
  @doc delegate_to: {Basic, :scan, 2}
  defdelegate scan(cursor, pattern), to: Basic

  @doc delegate_to: {Basic, :append, 2}
  defdelegate append(key, data), to: Basic
  @doc delegate_to: {Basic, :decr, 1}
  defdelegate decr(key), to: Basic
  @doc delegate_to: {Basic, :decrby, 2}
  defdelegate decrby(key, by), to: Basic
  @doc delegate_to: {Basic, :del, 1}
  defdelegate del(key), to: Basic
  @doc delegate_to: {Basic, :expire, 2}
  defdelegate expire(key, ttl), to: Basic
  @doc delegate_to: {Basic, :flushall, 0}
  defdelegate flushall, to: Basic
  @doc delegate_to: {Basic, :flushdb, 0}
  defdelegate flushdb, to: Basic
  @doc delegate_to: {Basic, :hdel, 2}
  defdelegate hdel(key, field), to: Basic
  @doc delegate_to: {Basic, :hmset, 2}
  defdelegate hmset(key, map_or_pairs), to: Basic
  @doc delegate_to: {Basic, :hscan, 3}
  defdelegate hscan(key, cursor, pattern), to: Basic
  @doc delegate_to: {Basic, :hset, 3}
  defdelegate hset(key, field, value), to: Basic
  @doc delegate_to: {Basic, :hsetnx, 3}
  defdelegate hsetnx(key, field, value), to: Basic
  @doc delegate_to: {Basic, :incr, 1}
  defdelegate incr(key), to: Basic
  @doc delegate_to: {Basic, :incrby, 2}
  defdelegate incrby(key, by), to: Basic
  @doc delegate_to: {Basic, :lindex, 2}
  defdelegate lindex(key, idx), to: Basic, as: :lindex
  @doc delegate_to: {Basic, :llen, 1}
  defdelegate llen(key), to: Basic, as: :llen
  @doc delegate_to: {Basic, :lpop, 1}
  defdelegate lpop(key), to: Basic, as: :lpop
  @doc delegate_to: {Basic, :lpush, 2}
  defdelegate lpush(key, data), to: Basic
  @doc delegate_to: {Basic, :lpushx, 2}
  defdelegate lpushx(key, data), to: Basic
  @doc delegate_to: {Basic, :lset, 3}
  defdelegate lset(key, index, value), to: Basic
  @doc delegate_to: {Basic, :mset, 1}
  defdelegate mset(map_or_pairs), to: Basic
  @doc delegate_to: {Basic, :prepend, 2}
  defdelegate prepend(key, list), to: Basic
  @doc delegate_to: {Basic, :rpop, 1}
  defdelegate rpop(key), to: Basic, as: :rpop
  @doc delegate_to: {Basic, :rpush, 2}
  defdelegate rpush(key, data), to: Basic
  @doc delegate_to: {Basic, :rpushx, 2}
  defdelegate rpushx(key, data), to: Basic
  @doc delegate_to: {Basic, :set, 2}
  defdelegate set(key, value), to: Basic
  @doc delegate_to: {Basic, :set, 3}
  defdelegate set(key, value, ttl), to: Basic
  @doc delegate_to: {Basic, :setex, 3}
  defdelegate setex(key, value, ttl), to: Basic
  @doc delegate_to: {Basic, :setnx, 2}
  defdelegate setnx(key, value), to: Basic

  @doc delegate_to: {Async, :append, 2}
  defdelegate async_append(key, data), to: Async, as: :append
  @doc delegate_to: {Async, :decr, 1}
  defdelegate async_decr(key), to: Async, as: :decr
  @doc delegate_to: {Async, :decrby, 2}
  defdelegate async_decrby(key, by), to: Async, as: :decrby
  @doc delegate_to: {Async, :del, 1}
  defdelegate async_del(key), to: Async, as: :del
  @doc delegate_to: {Async, :expire, 2}
  defdelegate async_expire(key, ttl), to: Async, as: :expire
  @doc delegate_to: {Async, :flushall, 0}
  defdelegate async_flushall, to: Async, as: :flushall
  @doc delegate_to: {Async, :flushdb, 0}
  defdelegate async_flushdb, to: Async, as: :flushdb
  @doc delegate_to: {Async, :hdel, 2}
  defdelegate async_hdel(key, field), to: Async, as: :hdel
  @doc delegate_to: {Async, :hmset, 2}
  defdelegate async_hmset(key, map_or_pairs), to: Async, as: :hmset
  @doc delegate_to: {Async, :hset, 3}
  defdelegate async_hset(key, field, value), to: Async, as: :hset
  @doc delegate_to: {Async, :hsetnx, 3}
  defdelegate async_hsetnx(key, field, value), to: Async, as: :hsetnx
  @doc delegate_to: {Async, :incr, 1}
  defdelegate async_incr(key), to: Async, as: :incr
  @doc delegate_to: {Async, :incrby, 2}
  defdelegate async_incrby(key, by), to: Async, as: :incrby
  @doc delegate_to: {Async, :lpush, 2}
  defdelegate async_lpush(key, data), to: Async, as: :lpush
  @doc delegate_to: {Async, :lpushx, 2}
  defdelegate async_lpushx(key, data), to: Async, as: :lpushx
  @doc delegate_to: {Async, :lset, 3}
  defdelegate async_lset(key, index, value), to: Async, as: :lset
  @doc delegate_to: {Async, :mset, 1}
  defdelegate async_mset(map_or_pairs), to: Async, as: :mset
  @doc delegate_to: {Async, :prepend, 2}
  defdelegate async_prepend(key, list), to: Async, as: :prepend
  @doc delegate_to: {Async, :rpush, 2}
  defdelegate async_rpush(key, data), to: Async, as: :rpush
  @doc delegate_to: {Async, :rpushx, 2}
  defdelegate async_rpushx(key, data), to: Async, as: :rpushx
  @doc delegate_to: {Async, :set, 2}
  defdelegate async_set(key, value), to: Async, as: :set
  @doc delegate_to: {Async, :set, 3}
  defdelegate async_set(key, value, ttl), to: Async, as: :set
  @doc delegate_to: {Async, :setex, 3}
  defdelegate async_setex(key, value, ttl), to: Async, as: :setex
  @doc delegate_to: {Async, :setnx, 2}
  defdelegate async_setnx(key, value), to: Async, as: :setnx

  defdelegate get_term(key), to: Term, as: :get
  defdelegate hget_term(key, field), to: Term, as: :hget
  defdelegate mget_term(any), to: Term, as: :mget
  defdelegate hmget_term(key, any), to: Term, as: :hmget
  defdelegate set_term(key, term), to: Term, as: :set
  defdelegate hset_term(key, field, term), to: Term, as: :hset
  defdelegate mset_term(any), to: Term, as: :mset
  defdelegate hmset_term(key, any), to: Term, as: :hmset
  defdelegate async_set_term(key, term), to: Term, as: :async_set
  defdelegate async_hset_term(key, field, term), to: Term, as: :async_hset
  defdelegate async_mset_term(any), to: Term, as: :async_mset
  defdelegate async_hmset_term(key, any), to: Term, as: :async_hmset
end
