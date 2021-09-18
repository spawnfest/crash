defmodule CrashWeb.PageLive do
  @moduledoc false

  use CrashWeb, :live_view

  alias Crash.Build.Engine

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :update, 100)
    end

    {:ok, assign(socket, builds: Engine.builds())}
  end

  @impl true
  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 100)

    {:noreply, assign(socket, builds: Engine.builds())}
  end

  @impl true
  def handle_event("update", _value, socket) do
    {:noreply, assign(socket, builds: Engine.builds())}
  end
end
