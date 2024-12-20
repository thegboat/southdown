defmodule Southdown.Pool do
  @moduledoc """
  Manages a pool of workers for Redis
  """

  use Supervisor
  @size 5

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts)
  end

  @spec init(list) :: no_return
  def init([]) do
    pool_opts = [
      name: {:local, :southdown},
      worker_module: Southdown.Worker,
      size: @size,
      max_overflow: 1,
      strategy: :fifo
    ]

    children = [
      :poolboy.child_spec(:southdown, pool_opts, [])
    ]

    Supervisor.init(children, strategy: :one_for_one, name: __MODULE__)
  end

  @spec size :: integer
  def size do
    @size
  end
end