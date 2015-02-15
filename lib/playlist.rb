# monkey patch playlist class
module RSpotify
  class Playlist < Base
    def remove_tracks(tracks)
      data = {
        tracks: tracks.map { |track| { uri: track.uri } }
      }
      puts data
      puts data.to_json
      url = "#{@href}/tracks?tracks=#{data.to_json}"
      puts "URL #{url}"
      User.oauth_delete(@owner.id, url)
      add_tracks(tracks)
      @total -= tracks.size
      @tracks_cache = nil
      tracks
    end
  end
end
