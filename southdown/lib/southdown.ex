defmodule Southdown do
  @moduledoc """
  Documentation for `Southdown`.
  """

  def start_link(_) do
    __MODULE__.Pool.start_link([])
  end

  
end
