require 'rspotify'
class PlaylistLoader
  STARRED = "starred"
  def initialize(user)
    @user = user
  end

  def all
    playlists = @user.playlists
    playlists << RSpotify::Playlist.find(@user.id, STARRED)
    playlists.map do |playlist|
      id = playlist.name.eql? "Starred" ? STARRED : playlist.id
      { id: id, name: playlist.name }
    end
    playlists.sort! { |x,y| x.name <=> y.name }
  end
end
