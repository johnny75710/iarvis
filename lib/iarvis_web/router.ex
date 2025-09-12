defmodule IarvisWeb.Router do
  use IarvisWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", IarvisWeb do
    pipe_through :api
  end
end
