defmodule TsWeb.GameController do
  use TsWeb, :controller

  def create(conn, _) do
    conn = set_user_id(conn)
    user_id = get_session(conn, "user_id")
    room_id = Ts.Server.RoomManager.new_room(user_id)

    redirect(conn, to: "/games/" <> room_id)
  end

  def register(conn, %{"room_id" => room_id}) do
    redirect(set_user_id(conn), to: "/games/" <> room_id)
  end

  def join(conn, _) do
    # TODO
  end

  def locale(conn, %{"locale" => locale}) do
    prev_locale = get_session(conn, "locale")

    if prev_locale == locale || !(locale in Gettext.known_locales(TsWeb.Gettext)) do
      send_resp(conn, 204, "")
    else
      conn
      |> put_session("locale", locale)
      |> redirect_back()
    end
  end

  defp gen_user_id do
    :crypto.strong_rand_bytes(16) |> Base.encode64() |> binary_part(0, 16)
  end

  defp set_user_id(conn) do
    user_id = get_session(conn, "user_id")

    if user_id do
      conn
    else
      user_id = gen_user_id()
      conn |> put_session("user_id", user_id)
    end
  end

  defp redirect_back(conn) do
    back_url =
      conn
      |> get_req_header("referer")
      |> Enum.at(0)
      |> URI.parse()
      |> Map.get(:path)

    conn |> redirect(to: back_url)
  end
end
