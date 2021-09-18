defmodule Crash.Support.Data do
  @moduledoc """
  Data manipulation utils module.
  """

  @doc """
  Converts a data with string keys to a data with existing atom keys.
  ## Examples
      iex> #{__MODULE__}.atomize_keys(nil)
      nil
      iex> #{__MODULE__}.atomize_keys(%{"one" => 1})
      %{one: 1}
      iex> #{__MODULE__}.atomize_keys([%{"one" => 1}, %{"one" => 2}])
      [%{one: 1}, %{one: 2}]
      iex> #{__MODULE__}.atomize_keys(%{"one" => %{"one" => 2}})
      %{one: %{one: 2}}
  """
  @spec atomize_keys(map | nil | list | struct) :: map | nil | list | struct
  def atomize_keys(nil), do: nil

  def atomize_keys(%{__struct__: _} = struct), do: struct

  def atomize_keys(%{} = map),
    # String.to_existing_atom saves us from overloading the VM by
    # creating too many atoms. It'll always succeed because all the fields
    # in the database already exist as atoms at runtime.
    do:
      Map.new(map, fn
        {k, v} when is_atom(k) ->
          {k, atomize_keys(v)}

        {k, v} when is_binary(k) ->
          {String.to_atom(k), atomize_keys(v)}
      end)

  def atomize_keys([head | rest]),
    do: [atomize_keys(head) | atomize_keys(rest)]

  def atomize_keys(not_a_map), do: not_a_map
end
