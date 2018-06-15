class Movie
  attr_accessor(:title, :description, :genre, :metascore, :stars, :rating,
  :director, :duration, :critic_tomatometer, :user_tomatometer, :role, :rating,
  :writer, :studio, :consensus, :year)
  
  @@all = []

  def initialize(movie_hash)
    student_hash.each { |key, value| self.send(("#{key}="), value) }
    self.class.all << self
  end

  def self.all
    @@all
  end
end
