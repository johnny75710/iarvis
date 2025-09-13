defmodule IarvisWeb.Router do
  use IarvisWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", IarvisWeb do
    pipe_through :api

  get "/categories", CategoryController, :index
  get "/categories/:id", CategoryController, :show
  post "/categories", CategoryController, :create
  end
end
