# monkey patch playlist class
module RSpotify
  class Playlist < Base
    def remove_tracks(tracks)
      url = "#{@href}/tracks"
      puts "URL #{url} TRACKS #{tracks}"
      User.oauth_delete(@owner.id, url, tracks)
      @total -= tracks.size
      @tracks_cache = nil
    end
  end
end
