defmodule Achieve.Router do
  use Achieve.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Achieve do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/auth", Achieve do
    pipe_through [:browser]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/init", Achieve do
    pipe_through [:browser]

    get "/", InitController, :index
    get "/do/new", InitController, :new
    get "/do/:owner/:id", InitController, :run
  end

  # Other scopes may use custom stacks.
  # scope "/api", Achieve do
  #   pipe_through :api
  # end
end
