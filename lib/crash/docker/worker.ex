defmodule Crash.Docker.Worker do
  @moduledoc false

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:square, x}, _from, state) do
    IO.puts("PID: #{inspect(self())} - #{x * x}")
    Process.sleep(1000)

    {:reply, x * x, state}
  end
end
