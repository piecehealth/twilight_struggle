defmodule TsWeb.GameController do
  use TsWeb, :controller

  def locale(conn, %{"locale" => locale}) do
    prev_locale = get_session(conn, :locale)

    if prev_locale == locale || !(locale in Gettext.known_locales(TsWeb.Gettext)) do
      send_resp(conn, 204, "")
    else
      back_url =
        conn
        |> get_req_header("referer")
        |> Enum.at(0)
        |> URI.parse()
        |> Map.get(:path)

      conn
      |> put_session(:locale, locale)
      |> redirect(to: back_url)
    end
  end
end
