defmodule TsWeb.PageLive do
  use TsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    countries = %{
      "n_korea" => 0,
      "s_korea" => 0
    }

    {:ok, assign(socket, countries: countries)}
  end

  @impl true
  def handle_event("incr", %{"country" => country}, socket) do
    countries = Map.update(socket.assigns.countries, country, 0, &(&1 + 1))
    {:noreply, assign(socket, countries: countries)}
  end
end
