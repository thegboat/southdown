defmodule Redis.Worker do
  @moduledoc """
  Worker that send commands and receives replies
  """

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{connection: connect()}, [])
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(cmds, _from, state) do
    {reply, state} = send_args(state, :pipeline, cmds)
    {:reply, reply, state}
  end

  def handle_cast(cmds, state) do
    {_reply, state} = send_args(state, :noreply_pipeline, cmds)
    {:noreply, state}
  end

  defp send_args(%{connection: nil} = state, send_type, cmds) do
    send_args(Map.put(state, :connection, connect()), send_type, cmds)
  end

  defp send_args(state, send_type, cmds) do
    case apply(Redix, send_type, [state.connection, cmds]) do
      {:error, %Redix.ConnectionError{}} = reply ->
        {reply, Map.put(state, :connection, nil)}

      reply ->
        {reply, state}
    end
  end

  defp connect do
    {:ok, conn} = Redix.start_link(config())
    conn
  end

  defp config do
    Keyword.delete(Application.get_all_env(:southdown), :included_applications)
  end
end
