require 'rspotify'
require_relative "playlist_track_loader"

class TrackRemover
  def initialize(playlist)
    @playlist = playlist
  end

  def remove(tracks)
    tracks_to_remove = []
    return tracks_to_remove unless tracks
    PlaylistTrackLoader.new(@playlist).all.each_with_index do |track, index|
      tracks.each do |other_track|
        if other_track.eql? track.id
          tracks_to_remove << {
            uri: track.uri,
            positions: [index]
          }
        end
      end
      tracks.delete(track.id)
    end
    puts tracks_to_remove
    @playlist.remove_tracks(tracks_to_remove)
  end
end
