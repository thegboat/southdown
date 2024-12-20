defmodule Southdown.Worker do
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

  def handle_call({exec_type, args}, _from, state) do
    {reply, state} = execute(state, exec_type, args)
    {:reply, reply, state}
  end

  def handle_cast({exec_type, args}, state) do
    {_reply, state} = execute(state, exec_type, args)
    {:noreply, state}
  end

  defp execute(%{connection: nil} = state, exec_type, args) do
    execute(Map.put(state, :connection, connect()), exec_type, args)
  end

  defp execute(state, exec_type, args) do
    case apply(Redix, exec_type, [state.connection, args]) do
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
    #Keyword.delete(Application.get_all_env(:southdown), :included_applications)
    [
      host: "127.0.0.1",
      password: nil,
      port: 6379,
      database: 1
    ]
  end
end
