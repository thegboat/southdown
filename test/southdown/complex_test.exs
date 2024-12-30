defmodule Southdown.ComplexTest do
  use ExUnit.Case, async: false
  import Mox
  alias Southdown.Complex

  setup do
    Mox.verify_on_exit!()
    Mox.set_mox_global()
    :ok
  end

  defmodule ComplexStruct do
    defstruct [
      :map,
      :list,
      :integer,
      :float,
      :string
    ]
  end

  describe "async_hmset/2" do
    test "issues correct arguments to adapter" do
      {struct1, dump1} = dumped()
      {struct2, dump2} = dumped()
      {struct3, dump3} = dumped()
      {struct4, dump4} = dumped()

      expect(FauxRedix, :noreply_command, fn _,
                                             [
                                               "HMSET",
                                               "key",
                                               "field1",
                                               ^dump1,
                                               "field2",
                                               ^dump2
                                             ] ->
        {:ok, "OK"}
      end)

      expect(FauxRedix, :noreply_command, fn _,
                                             [
                                               "HMSET",
                                               "key",
                                               "field3",
                                               ^dump3,
                                               "field4",
                                               ^dump4
                                             ] ->
        {:ok, "OK"}
      end)

      Complex.async_hmset("key", %{
        "field1" => struct1,
        "field2" => struct2,
        "field3" => struct3,
        "field4" => struct4
      })

      wait_for_async()
    end
  end

  describe "async_hset/3" do
    test "issues correct arguments to adapter" do
      {struct, dump} = dumped()

      expect(FauxRedix, :noreply_command, fn _, ["HSET", "key", "field", ^dump] ->
        {:ok, "OK"}
      end)

      Complex.async_hset("key", "field", struct)
      wait_for_async()
    end
  end

  describe "async_mset/1" do
    test "issues correct arguments to adapter" do
      {struct1, dump1} = dumped()
      {struct2, dump2} = dumped()

      expect(FauxRedix, :noreply_command, fn _, ["MSET", "key1", ^dump1, "key2", ^dump2] ->
        {:ok, "OK"}
      end)

      Complex.async_mset(%{"key1" => struct1, "key2" => struct2})
      wait_for_async()
    end
  end

  describe "async_set/2" do
    test "issues correct arguments to adapter" do
      {struct, dump} = dumped()
      expect(FauxRedix, :noreply_command, fn _, ["SET", "key", ^dump] -> {:ok, "OK"} end)
      Complex.async_set("key", struct)
      wait_for_async()
    end
  end

  describe "get/1" do
    test "issues correct arguments to adapter" do
      {struct, dump} = dumped()
      expect(FauxRedix, :command, fn _, ["GET", "key"] -> {:ok, dump} end)
      assert {:ok, struct} == Complex.get("key")
    end
  end

  describe "hget/2" do
    test "issues correct arguments to adapter" do
      {struct, dump} = dumped()
      expect(FauxRedix, :command, fn _, ["HGET", "key", "field"] -> {:ok, dump} end)
      assert {:ok, struct} == Complex.hget("key", "field")
    end
  end

  describe "hmget/2" do
    test "issues correct arguments to adapter when second arg is a pattern (binary)" do
      {struct1, dump1} = dumped()
      {struct2, dump2} = dumped()
      {struct3, dump3} = dumped()
      {struct4, dump4} = dumped()

      expect(FauxRedix, :command, fn _, ["HSCAN", "key", 0, "MATCH", "field*"] ->
        {:ok, ["1", ["field1", dump1, "field2", dump2]]}
      end)

      expect(FauxRedix, :command, fn _, ["HSCAN", "key", 1, "MATCH", "field*"] ->
        {:ok, ["0", ["field3", dump3, "field4", dump4]]}
      end)

      assert {:ok,
              %{
                "field1" => struct1,
                "field2" => struct2,
                "field3" => struct3,
                "field4" => struct4
              }} == Complex.hmget("key", "field*")
    end

    test "issues correct arguments to adapter when second arg is a list of fields" do
      {struct1, dump1} = dumped()
      {struct2, dump2} = dumped()
      {struct3, dump3} = dumped()
      {struct4, dump4} = dumped()

      expect(FauxRedix, :command, fn _,
                                     ["HMGET", "key", "field1", "field2", "field3", "field4"] ->
        {:ok, [dump1, dump2, dump3, dump4]}
      end)

      assert {:ok,
              %{
                "field1" => struct1,
                "field2" => struct2,
                "field3" => struct3,
                "field4" => struct4
              }} == Complex.hmget("key", ["field1", "field2", "field3", "field4"])
    end
  end

  describe "hmset/2" do
    test "issues correct arguments to adapter" do
      {struct1, dump1} = dumped()
      {struct2, dump2} = dumped()

      expect(FauxRedix, :command, fn _, ["HMSET", "key", "field1", ^dump1, "field2", ^dump2] ->
        {:ok, "OK"}
      end)

      Complex.hmset("key", %{"field1" => struct1, "field2" => struct2})
    end
  end

  describe "hset/3" do
    test "issues correct arguments to adapter" do
      {struct, dump} = dumped()
      expect(FauxRedix, :command, fn _, ["HSET", "key", "field", ^dump] -> {:ok, "OK"} end)
      Complex.hset("key", "field", struct)
    end
  end

  describe "mget/1" do
    test "issues correct arguments to adapter and returns a map when argument is a pattern (binary)" do
      {struct1, dump1} = dumped()
      {struct2, dump2} = dumped()
      {struct3, dump3} = dumped()
      {struct4, dump4} = dumped()

      expect(FauxRedix, :command, fn _, ["SCAN", 0, "MATCH", "key*"] ->
        {:ok, ["1", ["key1", "key2"]]}
      end)

      expect(FauxRedix, :command, fn _, ["SCAN", 1, "MATCH", "key*"] ->
        {:ok, ["0", ["key3", "key4"]]}
      end)

      expect(FauxRedix, :command, fn _, ["MGET", "key1", "key2"] ->
        {:ok, [dump1, dump2]}
      end)

      expect(FauxRedix, :command, fn _, ["MGET", "key3", "key4"] ->
        {:ok, [dump3, dump4]}
      end)

      assert {:ok,
              %{
                "key1" => struct1,
                "key2" => struct2,
                "key3" => struct3,
                "key4" => struct4
              }} == Complex.mget("key*")
    end

    test "issues correct arguments to adapter and returns a map when argument is a list of keys" do
      {struct1, dump1} = dumped()
      {struct2, dump2} = dumped()

      expect(FauxRedix, :command, fn _, ["MGET", "key1", "key2"] ->
        {:ok, [dump1, dump2]}
      end)

      assert {:ok,
              %{
                "key1" => struct1,
                "key2" => struct2
              }} == Complex.mget(["key1", "key2"])
    end
  end

  defp dumped do
    struct = random_struct()
    {struct, Complex.dump(struct)}
  end

  defp random_struct do
    %ComplexStruct{
      map: randmap(),
      list: randlist(),
      integer: randint(),
      float: randfloat(),
      string: randstring()
    }
  end

  defp randfloat, do: randint() + randint() / 100
  defp randint, do: :rand.uniform(100)
  defp randstring, do: to_string(Enum.shuffle(65..90))

  defp randlist do
    int = randint()
    Enum.into(int..(int + 1 + randint()), [])
  end

  defp randmap do
    randlist()
    |> Stream.chunk_every(2, 2, :discard)
    |> Stream.map(fn [k, v] -> {k, v} end)
    |> Enum.into(%{})
  end

  defp wait_for_async do
    :timer.sleep(1)
  end
end
