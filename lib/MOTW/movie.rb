
class Movie
  attr_accessor(  :cast, :consensus, :critic_tomatometer, :description,
                  :director, :duration, :genre, :metascore, :rated, :role,
                  :studio, :title, :user_tomatometer, :writer, :year  )
  @@list = []

  def initialize(movie_hash)
    movie_hash.each { |key, value| self.send(("#{key}="), value) }
    self
  end

  def self.list
    @@list
  end

  def self.reset!
    list.clear
  end

  def self.create_list(movies_array)
    movies_array.each { |movie|
      film = new(movie)
      film.save
    }
    list
  end

  def save
    self.class.list << self
  end
end
