defmodule CryServ.Discord do
  @moduledoc """
  Discord bot module
  """

  @spec update_status_count(number() | nil, number() | nil) :: :ok
  def update_status_count(players, server)

  def update_status_count(nil, nil) do
    Nostrum.Api.update_status(:invisible, nil, nil)
  end

  def update_status_count(0, 0) do
    Nostrum.Api.update_status(:dnd, "No servers online", 0)
  end

  def update_status_count(0, server) when server > 0 do
    Nostrum.Api.update_status(:idle, "No players online", 0)
  end

  def update_status_count(players, server) when players > 0 and server > 0 do
    Nostrum.Api.update_status(:online, "#{players} players online", 0)
  end
end
