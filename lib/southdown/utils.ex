defmodule Southdown.Utils do
  @moduledoc false

  def map_to_pairs(map) do
    Enum.flat_map(map, fn {key, value} ->
      [key, value]
    end)
  end

  def chunk_size do
    Application.get_env(:southdown, :chunk_size, 1000)
  end
end
