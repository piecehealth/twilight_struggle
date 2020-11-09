defmodule TsWeb.LiveHelpers do
  # import Phoenix.LiveView

  def assign_defaults(socket, session) do
    locale = Map.get(session, "locale") || Application.get_env(:gettext, :default_locale)
    Gettext.put_locale(TsWeb.Gettext, locale)

    # username = Map.get(session, "username")
    # assign(socket, :username, username)
    socket
  end
end
