# monkey patch playlist class
module RSpotify
  class Playlist < Base
    def remove_tracks(tracks)
      url = "#{@href}/tracks"
      User.oauth_delete(@owner.id, url)
      add_tracks(tracks)
      @total -= tracks.size
      @tracks_cache = nil
      tracks
    end
  end
end
