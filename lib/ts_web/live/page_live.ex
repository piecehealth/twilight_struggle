defmodule TsWeb.PageLive do
  use TsWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(socket, session)}
  end

  @impl true
  def handle_event("incr", %{"country" => country}, socket) do
    countries = Map.update(socket.assigns.countries, country, 0, &(&1 + 1))
    {:noreply, assign(socket, countries: countries)}
  end
end
