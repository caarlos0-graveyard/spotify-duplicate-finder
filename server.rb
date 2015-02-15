require "sinatra"
require "oauth2"
require "rspotify"
require "dotenv"
require "omniauth"
require "better_errors"
require_relative "./lib/playlist"
require_relative "./lib/similar_track_finder"
require_relative "./lib/playlist_loader"
require_relative "./lib/playlist_track_loader"
require_relative "./lib/track_remover"

Dotenv.load
enable :sessions
set :session_secret, ENV["SESSION_SECRET"]

configure :development do
  require "sinatra/reloader"
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path("..", __FILE__)
end

use OmniAuth::Builder do
  provider(
    :spotify,
    ENV["SPOTIFY_CLIENT_ID"],
    ENV["SPOTIFY_CLIENT_SECRET"],
    scope: %w(
      playlist-modify-public
      playlist-read-private
      playlist-modify-private
      user-library-read
      user-library-modify
    ).join(" ")
  )
end

TRACK_OFFSET = 100

def login
  redirect "/" unless session[:auth]
  @user = RSpotify::User.new(session[:auth])
end

get "/?" do
  erb :index
end

get "/playlists/?" do
  login
  @playlists = PlaylistLoader.new(@user).all
  erb :playlists
end

get "/playlists/:name/?" do
  login
  @playlist = RSpotify::Playlist.find(@user.id, params[:name])
  @tracks = SimilarTrackFinder.new.map(PlaylistTrackLoader.new(@playlist).all)
  erb :playlist
end

delete "/playlists/:name/remove" do
  login
  @playlist = RSpotify::Playlist.find(@user.id, params[:name])
  TrackRemover.new(@playlist).remove(params[:tracks])
  status 200
end

get "/auth/spotify/callback" do
  session[:auth] = request.env["omniauth.auth"]
  redirect "/playlists"
end
