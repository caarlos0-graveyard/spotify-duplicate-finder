require 'minitest/autorun'
require_relative "../lib/similar_track_finder.rb"

class Track
  attr_reader :id, :name
  def initialize(id, name)
    @id, @name = id, name
  end
end

describe SimilarTrackFinder do
  before do
    @finder = SimilarTrackFinder.new
  end

  it "should not break with nil track list" do
    @finder.map(nil).must_equal []
  end

  it "should not break with no track list" do
    @finder.map.must_equal []
  end

  it "should not break with an empty track list" do
    @finder.map([]).must_equal []
  end

  it "should map duplicates" do
    tracks = [Track.new(1, "Hit the lights"), Track.new(2, "Hit the lights")]
    @finder.map(tracks).must_equal tracks
  end

  it "should hide non-duplicates" do
    hit_the_lights = Track.new(1, "Hit the lights")
    the_unforgiven = Track.new(2, "The Unforgiven")
    tracks = [hit_the_lights, the_unforgiven]
    @finder.map(tracks).must_equal []
  end
end
