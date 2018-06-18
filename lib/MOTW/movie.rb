
class Movie
  attr_accessor(  :cast, :consensus, :critic_tomatometer, :description,
                  :director, :duration, :genre, :metascore, :rating, :rating,
                  :role, :studio, :title, :user_tomatometer, :writer, :year  )
  @@all = []

  def initialize(movie_hash)
    movie_hash.each { |key, value| self.send(("#{key}="), value) }
    self.class.all << self
  end

  def self.all
    @@all
  end

  def self.create_from_collection(movies_array)
    movies_array.each { |movie| new(movie) }
  end
end
