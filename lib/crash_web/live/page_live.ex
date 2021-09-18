defmodule CrashWeb.PageLive do
  @moduledoc false

  use CrashWeb, :live_view

  alias Crash.Build.Engine

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :update, 100)
    end

    {:ok, assign(socket, builds: Engine.builds(), build: nil)}
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

  def handle_event("build-details", %{"build" => build_id}, socket) do
    build = Engine.info(build_id)

    {:noreply, assign(socket, build: build, step: hd(build.completed_steps))}
  end

  def handle_event("step-details", %{"step" => step_name}, socket) do
    step = Enum.find(socket.assigns.build.completed_steps, fn s -> s.name == step_name end)

    {:noreply, assign(socket, step: step)}
  end
end
