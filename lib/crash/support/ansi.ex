defmodule Crash.Support.Ansi do
  @moduledoc false

  @ansi_regex ~r/(\x9B|\x1B\[)[0-?]*[ -\/]*[@-~]/

  @spec strip(binary()) :: binary()
  def strip(ansi_string) when is_binary(ansi_string) do
    Regex.replace(@ansi_regex, ansi_string, "")
  end
end
