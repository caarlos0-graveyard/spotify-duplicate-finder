require 'rspotify'

class PlaylistLoader
  def initialize(user)
    @user = user
  end

  def all
    playlists = @user.playlists
    playlists << RSpotify::Playlist.find(@user.id, "starred")
    sort(playlists).map do |playlist|
      { id: id_of(playlist), name: playlist.name }
    end
  end

  private

  def id_of(playlist)
    return "starred" if playlist.name.eql?("Starred")
    playlist.id
  end

  def sort(playlists)
    playlists.sort do |x, y|
      x.name <=> y.name
    end
  end
end
