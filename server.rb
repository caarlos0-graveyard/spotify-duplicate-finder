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
STARRED = "starred"

def find_playlist(name)
  RSpotify::Playlist.find(@user.id, name) if @user
end

def login
  redirect "/" unless session[:auth]
  @user = RSpotify::User.new(session[:auth])
end

def load_playlists
  playlists = @user.playlists
  playlists << find_playlist(STARRED)
  playlists.map do |playlist|
    id = playlist.name.eql? "Starred" ? STARRED : playlist.id
    { id: id, name: playlist.name }
  end
  playlists.sort! { |x,y| x.name <=> y.name }
end

def load_tracks(playlist)
  total = playlist.total
  offset = 0
  tracks = []
  while offset < total + TRACK_OFFSET
    tracks << playlist.tracks(limit: TRACK_OFFSET, offset: offset)
    offset += TRACK_OFFSET
  end
  tracks.flatten
end

def find_similar(tracks)
  mapped = {}
  tracks.map do |track|
    mapped << {name: track.name, tracks: []} unless mapped[track.name]
    mapped[track.name][tracks] << track
  end
  mapped
end

get "/" do
  erb :index
end

get "/playlists" do
  login
  @playlists = load_playlists
  erb :playlists
end

get "/playlists/:name" do
  login
  @playlist = find_playlist params[:name]
  @tracks = find_similar load_tracks(@playlist)
  erb :playlist
end

get "/auth/spotify/callback" do
  session[:auth] = request.env["omniauth.auth"]
  redirect "/playlists"
end
