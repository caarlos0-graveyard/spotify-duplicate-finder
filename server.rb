require "sinatra"
require "oauth2"
require "rspotify"
require "dotenv"
require "omniauth"
require "better_errors"

Dotenv.load
enable :sessions
set :session_secret, ENV["SESSION_SECRET"]

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path("..", __FILE__)
end

use OmniAuth::Builder do
  provider(
    :spotify,
    ENV["SPOTIFY_CLIENT_ID"],
    ENV["SPOTIFY_CLIENT_SECRET"],
    scope: "playlist-modify-public playlist-read-private playlist-modify-private"
  )
end

get "/" do
  <<-HTML
  <a href="/auth/spotify">Sign in with Spotify</a>
  HTML
end

get "/auth/spotify/callback" do
  session[:auth] = request.env["omniauth.auth"]
  puts "DEU"
  "FOI"
end
