require_relative "mapped_track"

class SimilarTrackFinder
  def map(tracks = [])
    return [] unless tracks
    remove_uniques map_by_name(tracks)
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

  def remove_uniques(mapped)
    mapped.select do |track|
      mapped[track].get.size > 1
    end.map do |track|
      # this is weird...
      track.last.get
    end.flatten
  end
end
