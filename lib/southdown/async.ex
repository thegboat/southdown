defmodule Southdown.Async do
  @moduledoc false
  use Southdown.Modify

  def flush_all do
    command(["FLUSHALL", "ASYNC"])
  end

  def flush_db do
    command(["FLUSHDB", "ASYNC"])
  end

  defp command(cmd) do
    :poolboy.transaction(:southdown, &GenServer.cast(&1, {:noreply_command, cmd}))
    :ok
  end
end