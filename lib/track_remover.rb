require 'rspotify'

class TrackRemover
  def initialize(playlist)
    @playlist = playlist
  end

  def remove(tracks)
    @playlist.remove_tracks(RSpotify::Track.find(tracks))
  end
end
