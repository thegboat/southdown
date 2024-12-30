defmodule SouthdownTest do
  use ExUnit.Case, async: false
  import Mox

  setup do
    Mox.verify_on_exit!()
    Mox.set_mox_global()
    :ok
  end

  describe "command/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["SET", "key", "value"] -> {:ok, "OK"} end)
      Southdown.command(["SET", "key", "value"])
    end
  end

  describe "pipeline/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :pipeline, fn _, [["SET", "key1", "value1"], ["SET", "key2", "value2"]] ->
        {:ok, "OK"}
      end)

      Southdown.pipeline([["SET", "key1", "value1"], ["SET", "key2", "value2"]])
    end
  end

  describe "noreply_command/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["SET", "key", "value"] -> {:ok, "OK"} end)
      Southdown.noreply_command(["SET", "key", "value"])
    end
  end

  describe "noreply_pipeline/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_pipeline, fn _,
                                              [
                                                ["SET", "key1", "value1"],
                                                ["SET", "key2", "value2"]
                                              ] ->
        {:ok, "OK"}
      end)

      Southdown.noreply_pipeline([["SET", "key1", "value1"], ["SET", "key2", "value2"]])
    end
  end

  describe "transaction_pipeline/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :transaction_pipeline, fn _,
                                                  [
                                                    ["SET", "key1", "value1"],
                                                    ["SET", "key2", "value2"]
                                                  ] ->
        {:ok, "OK"}
      end)

      Southdown.transaction_pipeline([["SET", "key1", "value1"], ["SET", "key2", "value2"]])
    end
  end

  describe "append/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["RPUSH", "key", "value1"] -> {:ok, "OK"} end)
      Southdown.append("key", "value1")
    end

    test "can 'append' multiple values" do
      expect(FauxRedix, :command, fn _, ["RPUSH", "key", "value1", "value2", "value3"] ->
        {:ok, "OK"}
      end)

      Southdown.append("key", ["value1", "value2", "value3"])
    end
  end

  describe "decr/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["DECRBY", "key", 1] -> {:ok, "OK"} end)
      Southdown.decr("key")
    end
  end

  describe "decrby/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["DECRBY", "key", 2] -> {:ok, "OK"} end)
      Southdown.decrby("key", 2)
    end
  end

  describe "del/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["DEL", "key"] -> {:ok, "OK"} end)
      Southdown.del("key")
    end
  end

  describe "expire/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["EXPIRE", "key", 3600] -> {:ok, "OK"} end)
      Southdown.expire("key", 3600)
    end
  end

  describe "hdel/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["HDEL", "key", "field"] -> {:ok, "OK"} end)
      Southdown.hdel("key", "field")
    end
  end

  describe "hmset/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _,
                                     ["HMSET", "key", "field1", "value1", "field2", "value2"] ->
        {:ok, "OK"}
      end)

      Southdown.hmset("key", %{"field1" => "value1", "field2" => "value2"})
    end
  end

  describe "hset/3" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["HSET", "key", "field", "value"] -> {:ok, "OK"} end)
      Southdown.hset("key", "field", "value")
    end
  end

  describe "hsetnx/3" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["HSETNX", "key", "field", "value"] -> {:ok, "OK"} end)
      Southdown.hsetnx("key", "field", "value")
    end
  end

  describe "incr/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["INCRBY", "key", 1] -> {:ok, "OK"} end)
      Southdown.incr("key")
    end
  end

  describe "incrby/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["INCRBY", "key", 2] -> {:ok, "OK"} end)
      Southdown.incrby("key", 2)
    end
  end

  describe "lpush/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["LPUSH", "key", "value1"] -> {:ok, "OK"} end)
      Southdown.lpush("key", "value1")
    end

    test "can 'lpush' multiple values" do
      expect(FauxRedix, :command, fn _, ["LPUSH", "key", "value1", "value2", "value3"] ->
        {:ok, "OK"}
      end)

      Southdown.lpush("key", ["value1", "value2", "value3"])
    end
  end

  describe "lpushx/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["LPUSHX", "key", "value1"] -> {:ok, "OK"} end)
      Southdown.lpushx("key", "value1")
    end

    test "can 'lpushx' multiple values" do
      expect(FauxRedix, :command, fn _, ["LPUSHX", "key", "value1", "value2", "value3"] ->
        {:ok, "OK"}
      end)

      Southdown.lpushx("key", ["value1", "value2", "value3"])
    end
  end

  describe "lset/3" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["LSET", "key", 0, "value"] -> {:ok, "OK"} end)
      Southdown.lset("key", 0, "value")
    end
  end

  describe "mset/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["MSET", "key1", "value1", "key2", "value2"] ->
        {:ok, "OK"}
      end)

      Southdown.mset(%{"key1" => "value1", "key2" => "value2"})
    end
  end

  describe "prepend/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["LPUSH", "key", "value1"] -> {:ok, "OK"} end)
      Southdown.prepend("key", "value1")
    end

    test "can 'prepend' multiple values" do
      expect(FauxRedix, :command, fn _, ["LPUSH", "key", "value1", "value2", "value3"] ->
        {:ok, "OK"}
      end)

      Southdown.prepend("key", ["value1", "value2", "value3"])
    end
  end

  describe "rpush/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["RPUSH", "key", "value1"] -> {:ok, "OK"} end)
      Southdown.rpush("key", "value1")
    end

    test "can 'rpush' multiple values" do
      expect(FauxRedix, :command, fn _, ["RPUSH", "key", "value1", "value2", "value3"] ->
        {:ok, "OK"}
      end)

      Southdown.rpush("key", ["value1", "value2", "value3"])
    end
  end

  describe "rpushx/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["RPUSHX", "key", "value1"] -> {:ok, "OK"} end)
      Southdown.rpushx("key", "value1")
    end

    test "can 'rpushx' multiple values" do
      expect(FauxRedix, :command, fn _, ["RPUSHX", "key", "value1", "value2", "value3"] ->
        {:ok, "OK"}
      end)

      Southdown.rpushx("key", ["value1", "value2", "value3"])
    end
  end

  describe "set/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["SET", "key", "value"] -> {:ok, "OK"} end)
      Southdown.set("key", "value")
    end
  end

  describe "set/3" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["SET", "key", "value", "EX", 3600] -> {:ok, "OK"} end)
      Southdown.set("key", "value", 3600)
    end
  end

  describe "setex/3" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["SET", "key", "value", "EX", 3600] -> {:ok, "OK"} end)
      Southdown.set("key", "value", 3600)
    end
  end

  describe "setnx/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["SETNX", "key", "value"] -> {:ok, "OK"} end)
      Southdown.setnx("key", "value")
    end
  end

  describe "async_append/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["RPUSH", "key", "value1"] -> {:ok, "OK"} end)
      Southdown.async_append("key", "value1")
      wait_for_async()
    end

    test "can 'append' multiple values" do
      expect(FauxRedix, :noreply_command, fn _, ["RPUSH", "key", "value1", "value2", "value3"] ->
        {:ok, "OK"}
      end)

      Southdown.async_append("key", ["value1", "value2", "value3"])
      wait_for_async()
    end
  end

  describe "async_decr/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["DECRBY", "key", 1] -> {:ok, "OK"} end)
      Southdown.async_decr("key")
      wait_for_async()
    end
  end

  describe "async_decrby/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["DECRBY", "key", 2] -> {:ok, "OK"} end)
      Southdown.async_decrby("key", 2)
      wait_for_async()
    end
  end

  describe "async_del/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["DEL", "key"] -> {:ok, "OK"} end)
      Southdown.async_del("key")
      wait_for_async()
    end
  end

  describe "async_expire/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["EXPIRE", "key", 3600] -> {:ok, "OK"} end)
      Southdown.async_expire("key", 3600)
      wait_for_async()
    end
  end

  describe "async_hdel/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["HDEL", "key", "field"] -> {:ok, "OK"} end)
      Southdown.async_hdel("key", "field")
      wait_for_async()
    end
  end

  describe "async_hmset/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _,
                                             [
                                               "HMSET",
                                               "key",
                                               "field1",
                                               "value1",
                                               "field2",
                                               "value2"
                                             ] ->
        {:ok, "OK"}
      end)

      expect(FauxRedix, :noreply_command, fn _,
                                             [
                                               "HMSET",
                                               "key",
                                               "field3",
                                               "value3",
                                               "field4",
                                               "value4"
                                             ] ->
        {:ok, "OK"}
      end)

      Southdown.async_hmset("key", %{
        "field1" => "value1",
        "field2" => "value2",
        "field3" => "value3",
        "field4" => "value4"
      })

      wait_for_async()
    end
  end

  describe "async_hset/3" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["HSET", "key", "field", "value"] ->
        {:ok, "OK"}
      end)

      Southdown.async_hset("key", "field", "value")
      wait_for_async()
    end
  end

  describe "async_hsetnx/3" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["HSETNX", "key", "field", "value"] ->
        {:ok, "OK"}
      end)

      Southdown.async_hsetnx("key", "field", "value")
      wait_for_async()
    end
  end

  describe "async_incr/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["INCRBY", "key", 1] -> {:ok, "OK"} end)
      Southdown.async_incr("key")
      wait_for_async()
    end
  end

  describe "async_incrby/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["INCRBY", "key", 2] -> {:ok, "OK"} end)
      Southdown.async_incrby("key", 2)
      wait_for_async()
    end
  end

  describe "async_lpush/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["LPUSH", "key", "value1"] -> {:ok, "OK"} end)
      Southdown.async_lpush("key", "value1")
      wait_for_async()
    end

    test "can 'lpush' multiple values" do
      expect(FauxRedix, :noreply_command, fn _, ["LPUSH", "key", "value1", "value2", "value3"] ->
        {:ok, "OK"}
      end)

      Southdown.async_lpush("key", ["value1", "value2", "value3"])
      wait_for_async()
    end
  end

  describe "async_lpushx/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["LPUSHX", "key", "value1"] -> {:ok, "OK"} end)
      Southdown.async_lpushx("key", "value1")
      wait_for_async()
    end

    test "can 'lpushx' multiple values" do
      expect(FauxRedix, :noreply_command, fn _, ["LPUSHX", "key", "value1", "value2", "value3"] ->
        {:ok, "OK"}
      end)

      Southdown.async_lpushx("key", ["value1", "value2", "value3"])
      wait_for_async()
    end
  end

  describe "async_lset/3" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["LSET", "key", 0, "value"] -> {:ok, "OK"} end)
      Southdown.async_lset("key", 0, "value")
      wait_for_async()
    end
  end

  describe "async_mset/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["MSET", "key1", "value1", "key2", "value2"] ->
        {:ok, "OK"}
      end)

      Southdown.async_mset(%{"key1" => "value1", "key2" => "value2"})
      wait_for_async()
    end
  end

  describe "async_prepend/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["LPUSH", "key", "value1"] -> {:ok, "OK"} end)
      Southdown.async_prepend("key", "value1")
      wait_for_async()
    end

    test "can 'prepend' multiple values" do
      expect(FauxRedix, :noreply_command, fn _, ["LPUSH", "key", "value1", "value2", "value3"] ->
        {:ok, "OK"}
      end)

      Southdown.async_prepend("key", ["value1", "value2", "value3"])
      wait_for_async()
    end
  end

  describe "async_rpush/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["RPUSH", "key", "value1"] -> {:ok, "OK"} end)
      Southdown.async_rpush("key", "value1")
      wait_for_async()
    end

    test "can 'rpush' multiple values" do
      expect(FauxRedix, :noreply_command, fn _, ["RPUSH", "key", "value1", "value2", "value3"] ->
        {:ok, "OK"}
      end)

      Southdown.async_rpush("key", ["value1", "value2", "value3"])
      wait_for_async()
    end
  end

  describe "async_rpushx/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["RPUSHX", "key", "value1"] -> {:ok, "OK"} end)
      Southdown.async_rpushx("key", "value1")
      wait_for_async()
    end

    test "can 'rpushx' multiple values" do
      expect(FauxRedix, :noreply_command, fn _, ["RPUSHX", "key", "value1", "value2", "value3"] ->
        {:ok, "OK"}
      end)

      Southdown.async_rpushx("key", ["value1", "value2", "value3"])
      wait_for_async()
    end
  end

  describe "async_set/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["SET", "key", "value"] -> {:ok, "OK"} end)
      Southdown.async_set("key", "value")
      wait_for_async()
    end
  end

  describe "async_set/3" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["SET", "key", "value", "EX", 3600] ->
        {:ok, "OK"}
      end)

      Southdown.async_set("key", "value", 3600)
      wait_for_async()
    end
  end

  describe "async_setex/3" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["SET", "key", "value", "EX", 3600] ->
        {:ok, "OK"}
      end)

      Southdown.async_set("key", "value", 3600)
      wait_for_async()
    end
  end

  describe "async_setnx/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["SETNX", "key", "value"] -> {:ok, "OK"} end)
      Southdown.async_setnx("key", "value")
      wait_for_async()
    end
  end

  describe "async_flushall/0" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["FLUSHALL", "ASYNC"] -> {:ok, "OK"} end)
      Southdown.async_flushall()
      wait_for_async()
    end
  end

  describe "async_flushdb/0" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :noreply_command, fn _, ["FLUSHDB", "ASYNC"] -> {:ok, "OK"} end)
      Southdown.async_flushdb()
      wait_for_async()
    end
  end

  describe "exists/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["EXISTS", "key"] -> {:ok, 1} end)
      Southdown.exists("key")
    end
  end

  describe "exists?/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["EXISTS", "key"] -> {:ok, 1} end)
      Southdown.exists?("key")
    end

    test "returns true when the Redis responds with 'exists" do
      expect(FauxRedix, :command, fn _, ["EXISTS", "key"] -> {:ok, 1} end)
      assert true == Southdown.exists?("key")
    end

    test "returns false when the Redis responds with 'not exists" do
      expect(FauxRedix, :command, fn _, ["EXISTS", "key"] -> {:ok, 0} end)
      assert false == Southdown.exists?("key")
    end
  end

  describe "first/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["LINDEX", "key", 0] -> {:ok, "value"} end)
      Southdown.first("key")
    end
  end

  describe "get/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["GET", "key"] -> {:ok, "value"} end)
      Southdown.get("key")
    end
  end

  describe "getall/0" do
    test "issues correct arguments to adapter and returns a map" do
      expect(FauxRedix, :command, fn _, ["SCAN", 0, "MATCH", "*"] ->
        {:ok, ["1", ["key1", "key2"]]}
      end)

      expect(FauxRedix, :command, fn _, ["SCAN", 1, "MATCH", "*"] ->
        {:ok, ["0", ["key3", "key4"]]}
      end)

      expect(FauxRedix, :command, fn _, ["MGET", "key1", "key2"] ->
        {:ok, ["value1", "value2"]}
      end)

      expect(FauxRedix, :command, fn _, ["MGET", "key3", "key4"] ->
        {:ok, ["value3", "value4"]}
      end)

      assert {:ok,
              %{
                "key1" => "value1",
                "key2" => "value2",
                "key3" => "value3",
                "key4" => "value4"
              }} = Southdown.getall()
    end
  end

  describe "getdel/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["GETDEL", "key"] -> {:ok, "OK"} end)
      Southdown.getdel("key")
    end
  end

  describe "getex/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["GET", "key", "EX", 3600] -> {:ok, "OK"} end)
      Southdown.getex("key", 3600)
    end
  end

  describe "getlist/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["LRANGE", "key", 0, -1] ->
        {:ok, ["value2", "value3"]}
      end)

      Southdown.getlist("key")
    end
  end

  describe "getrange/3" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["GETRANGE", "key", 1, 10] -> {:ok, "substring"} end)
      Southdown.getrange("key", 1, 10)
    end
  end

  describe "getset/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["GETSET", "key", "value"] -> {:ok, "oldvalue"} end)
      Southdown.getset("key", "value")
    end
  end

  describe "hget/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["HGET", "key", "field"] -> {:ok, "value"} end)
      Southdown.hget("key", "field")
    end
  end

  describe "hkeys/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["HSCAN", "key", 0, "MATCH", "*"] ->
        {:ok, ["1", ["field1", "value1", "field2", "value2"]]}
      end)

      expect(FauxRedix, :command, fn _, ["HSCAN", "key", 1, "MATCH", "*"] ->
        {:ok, ["0", ["field3", "value3", "field4", "value4"]]}
      end)

      assert {:ok, ["field1", "field2", "field3", "field4"]} = Southdown.hkeys("key")
    end
  end

  describe "hkeys/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["HSCAN", "key", 0, "MATCH", "field*"] ->
        {:ok, ["1", ["field1", "value1", "field2", "value2"]]}
      end)

      expect(FauxRedix, :command, fn _, ["HSCAN", "key", 1, "MATCH", "field*"] ->
        {:ok, ["0", ["field3", "value3", "field4", "value4"]]}
      end)

      assert {:ok, ["field1", "field2", "field3", "field4"]} = Southdown.hkeys("key", "field*")
    end
  end

  describe "hgetall/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["HGETALL", "key"] ->
        {:ok, ["field1", "value1", "field2", "value2"]}
      end)

      assert {:ok,
              %{
                "field1" => "value1",
                "field2" => "value2"
              }} = Southdown.hgetall("key")
    end
  end

  describe "hmget/2" do
    test "issues correct arguments to adapter when second arg is a pattern (binary)" do
      expect(FauxRedix, :command, fn _, ["HSCAN", "key", 0, "MATCH", "field*"] ->
        {:ok, ["1", ["field1", "value1", "field2", "value2"]]}
      end)

      expect(FauxRedix, :command, fn _, ["HSCAN", "key", 1, "MATCH", "field*"] ->
        {:ok, ["0", ["field3", "value3", "field4", "value4"]]}
      end)

      assert {:ok,
              %{
                "field1" => "value1",
                "field2" => "value2",
                "field3" => "value3",
                "field4" => "value4"
              }} = Southdown.hmget("key", "field*")
    end

    test "issues correct arguments to adapter when second arg is a list of fields" do
      expect(FauxRedix, :command, fn _,
                                     ["HMGET", "key", "field1", "field2", "field3", "field4"] ->
        {:ok, ["value1", "value2", "value3", "value4"]}
      end)

      assert {:ok,
              %{
                "field1" => "value1",
                "field2" => "value2",
                "field3" => "value3",
                "field4" => "value4"
              }} = Southdown.hmget("key", ["field1", "field2", "field3", "field4"])
    end
  end

  describe "keys" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["SCAN", 0, "MATCH", "*"] ->
        {:ok, ["1", ["key1", "key2"]]}
      end)

      expect(FauxRedix, :command, fn _, ["SCAN", 1, "MATCH", "*"] ->
        {:ok, ["0", ["key3", "key4"]]}
      end)

      assert {:ok,
              [
                "key1",
                "key2",
                "key3",
                "key4"
              ]} = Southdown.keys()
    end
  end

  describe "keys/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["SCAN", 0, "MATCH", "key*"] ->
        {:ok, ["1", ["key1", "key2"]]}
      end)

      expect(FauxRedix, :command, fn _, ["SCAN", 1, "MATCH", "key*"] ->
        {:ok, ["0", ["key3", "key4"]]}
      end)

      assert {:ok,
              [
                "key1",
                "key2",
                "key3",
                "key4"
              ]} = Southdown.keys("key*")
    end
  end

  describe "last/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["LINDEX", "key", -1] -> {:ok, "value"} end)
      Southdown.last("key")
    end
  end

  describe "lindex/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["LINDEX", "key", 2] -> {:ok, "value"} end)
      Southdown.lindex("key", 2)
    end
  end

  describe "llen/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["LLEN", "key"] -> {:ok, 3} end)
      Southdown.llen("key")
    end
  end

  describe "lpop/1" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["LPOP", "key"] -> {:ok, "value"} end)
      Southdown.lpop("key")
    end
  end

  describe "lrange/3" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["LRANGE", "key", 2, 3] -> {:ok, ["value2", "value3"]} end)

      Southdown.lrange("key", 2, 3)
    end
  end

  describe "mget/1" do
    test "issues correct arguments to adapter and returns a map when argument is a pattern (binary)" do
      expect(FauxRedix, :command, fn _, ["SCAN", 0, "MATCH", "key*"] ->
        {:ok, ["1", ["key1", "key2"]]}
      end)

      expect(FauxRedix, :command, fn _, ["SCAN", 1, "MATCH", "key*"] ->
        {:ok, ["0", ["key3", "key4"]]}
      end)

      expect(FauxRedix, :command, fn _, ["MGET", "key1", "key2"] ->
        {:ok, ["value1", "value2"]}
      end)

      expect(FauxRedix, :command, fn _, ["MGET", "key3", "key4"] ->
        {:ok, ["value3", "value4"]}
      end)

      assert {:ok,
              %{
                "key1" => "value1",
                "key2" => "value2",
                "key3" => "value3",
                "key4" => "value4"
              }} = Southdown.mget("key*")
    end

    test "issues correct arguments to adapter and returns a map when argument is a list of keys" do
      expect(FauxRedix, :command, fn _, ["MGET", "key1", "key2"] ->
        {:ok, ["value1", "value2"]}
      end)

      assert {:ok,
              %{
                "key1" => "value1",
                "key2" => "value2"
              }} = Southdown.mget(["key1", "key2"])
    end
  end

  describe "scan/2" do
    test "issues correct arguments to adapter" do
      expect(FauxRedix, :command, fn _, ["SCAN", 1, "MATCH", "*"] ->
        {:ok, ["0", ["key3", "key4"]]}
      end)

      Southdown.scan(1, "*")
    end
  end

  defp wait_for_async do
    :timer.sleep(1)
  end
end
