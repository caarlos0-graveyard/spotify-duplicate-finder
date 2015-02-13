class MappedTrack
  attr_reader :name

  def initialize(name)
    @name, @tracks = name, []
  end

  def get
    @tracks
  end

  def <<(track)
    @tracks << track
  end

  def to_s
    "Mapped tracks for \"#{@name}\""
  end
end
