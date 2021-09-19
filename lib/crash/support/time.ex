defmodule Crash.Support.Time do
  @moduledoc false

  alias Timex.Duration

  @doc """
  Converts seconds to a well formatter string of h d m s

  ## Examples

      iex> #{__MODULE__}.format_duration(Timex.Duration.from_seconds(0))
      ""
      iex> #{__MODULE__}.format_duration(Timex.Duration.from_seconds(10))
      "10s"
      iex> #{__MODULE__}.format_duration(Timex.Duration.from_seconds(60))
      "1m"
      iex> #{__MODULE__}.format_duration(Timex.Duration.from_seconds(61))
      "1m 1s"
      iex> #{__MODULE__}.format_duration(Timex.Duration.from_seconds(60*60))
      "1h"
      iex> #{__MODULE__}.format_duration(Timex.Duration.from_seconds(60*60+1))
      "1h 1s"
      iex> #{__MODULE__}.format_duration(Timex.Duration.from_seconds(24*60*60))
      "1d"
      iex> #{__MODULE__}.format_duration(Timex.Duration.from_seconds(74108612))
      "857d 17h 43m 32s"
  """
  @spec format_duration(Duration.t()) :: String.t()
  def format_duration(duration) do
    days = Duration.to_days(duration, truncate: true)
    hours = Duration.to_hours(duration, truncate: true)
    minutes = Duration.to_minutes(duration, truncate: true)
    seconds = Duration.to_seconds(duration, truncate: true)

    [
      {days, "d"},
      {Integer.mod(hours, 24), "h"},
      {Integer.mod(minutes, 60), "m"},
      {Integer.mod(seconds, 60), "s"}
    ]
    |> Enum.filter(fn {m, _} -> m > 0 end)
    |> Enum.map(fn {m, s} -> to_string(m) <> s end)
    |> Enum.join(" ")
  end
end
