defmodule TsWeb.GameController do
  use TsWeb, :controller

  def create(conn, _) do
    user_id = :crypto.strong_rand_bytes(16) |> Base.encode64() |> binary_part(0, 16)

    conn
    |> put_session(:user_id, user_id)
    |> redirect(to: "/")
  end

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
