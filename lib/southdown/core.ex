defmodule Southdown.Core do
  @moduledoc """
  Core module for interacting with Redis.
  """

  def command(cmd) do
    :poolboy.transaction(:southdown, &GenServer.call(&1, {:command, cmd}))
  end

  def pipeline(cmds) do
    :poolboy.transaction(:southdown, &GenServer.call(&1, {:pipeline, cmds}))
  end

  def noreply_command(cmd) do
    :poolboy.transaction(:southdown, &GenServer.call(&1, {:noreply_command, cmd}))
  end

  def noreply_pipeline(cmds) do
    :poolboy.transaction(:southdown, &GenServer.call(&1, {:noreply_pipeline, cmds}))
  end

  def transaction_pipeline(cmds) do
    :poolboy.transaction(:southdown, &GenServer.call(&1, {:transaction_pipeline, cmds}))
  end
end
