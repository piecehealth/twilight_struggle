defmodule TsWeb.LiveHelpers do
  import Phoenix.LiveView

  def assign_defaults(socket, session) do
    locale = Map.get(session, :locale) || Application.get_env(:gettext, :default_locale)
    Gettext.put_locale(TsWeb.Gettext, locale)

    user_id = Map.get(session, :user_id)
    assign(socket, user_id: user_id)
  end
end
