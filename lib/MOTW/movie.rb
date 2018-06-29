
class Movie
  attr_accessor(  :cast, :critic_tomatometer, :description, :metascore,
                  :title, :user_tomatometer, :year  )
  #@@list = []

  def initialize(movie_hash)
    movie_hash.each { |key, value| self.send(("#{key}="), value) }
    self
  end

=begin
  def self.list
    @@list
  end

  def self.reset!
    list.clear
  end
=end

  def self.create_list(movies_array)
    list = []
    movies_array.each do |movie|
      list << new(movie)
    end
    list
  end

end
