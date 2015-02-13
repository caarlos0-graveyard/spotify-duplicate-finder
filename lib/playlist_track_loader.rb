class PlaylistTrackLoader
  LIMIT = 100

  def initialize(playlist)
    @playlist = playlist
    @total = playlist.total
  end

  def all
    tracks = []
    offset = 0
    while offset < @total + LIMIT
      tracks << @playlist.tracks(limit: LIMIT, offset: offset)
      offset += LIMIT
    end
    tracks.flatten
  end
end
