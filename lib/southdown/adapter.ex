defmodule Southdown.Adapter do
  @moduledoc false

  @callback command(any(), list(String.t() | integer())) :: {:ok, any()} | {:error, any()}
  @callback pipeline(any(), list(String.t() | integer())) :: {:ok, any()} | {:error, any()}
  @callback noreply_command(any(), list(list(String.t() | integer()))) ::
              {:ok, any()} | {:error, any()}
  @callback noreply_pipeline(any(), list(list(String.t() | integer()))) ::
              {:ok, any()} | {:error, any()}
  @callback transaction_pipeline(any(), list(list(String.t() | integer()))) ::
              {:ok, any()} | {:error, any()}

  def start_link(opts) do
    case impl() do
      FauxRedix -> {:ok, self()}
      mod -> mod.start_link(opts)
    end
  end

  def command(conn, cmd), do: impl().command(conn, cmd)
  def pipeline(conn, cmds), do: impl().pipeline(conn, cmds)
  def noreply_command(conn, cmd), do: impl().noreply_command(conn, cmd)
  def noreply_pipeline(conn, cmds), do: impl().noreply_pipeline(conn, cmds)
  def transaction_pipeline(conn, cmds), do: impl().transaction_pipeline(conn, cmds)

  defp impl, do: Application.get_env(:southdown, :adapter, Redix)
end
