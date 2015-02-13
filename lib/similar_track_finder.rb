require_relative "mapped_track"

class SimilarTrackFinder
  def map(tracks = [])
    return [] unless tracks
    mapped = map_by_name(tracks)
    mapped.select do |track|
      mapped[track].get.size > 1
    end.map do |track|
      track.last.get
    end.flatten
  end

  private

  def map_by_name(tracks)
    mapped = Hash.new
    tracks.map do |track|
      mapped[track.name] = MappedTrack.new(track.name) unless mapped[track.name]
      mapped[track.name] << track
    end
    mapped
  end
end
