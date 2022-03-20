defmodule PrintWeb.PageController do
  use PrintWeb, :controller

  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def print(conn, _params) do
    Logger.info("Print")

    render(conn, "print.html")
  end

  def upload_print(
        conn,
        %{
          "_csrf_token" => _,
          "file_details" => %{
            "filename" => %Plug.Upload{
              content_type: _content_type,
              filename: _filename,
              path: path
            }
          }
        } = params
      ) do
    Logger.info("About to start printing")

    Logger.info("#{inspect(params)}")

    if Application.get_env(:print, :should_print) do
      Logger.info("Sent to printer")
      System.cmd("lp", ["#{path}"])

      conn
      |> put_flash(:info, "Tried to print, go check it out")
      |> redirect(to: "/print")
    else
      conn
      |> put_flash(:info, "In test mode, no printing")
      |> redirect(to: "/print")
    end
  end

  def upload_print(conn, params) do
    Logger.info("Upload print")

    IO.inspect(params)

    conn
    |> put_flash(:info, "you didnt pass a file")
    |> redirect(to: "/print")
  end
end
