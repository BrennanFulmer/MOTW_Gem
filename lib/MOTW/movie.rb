
class Movie
  attr_accessor(  :cast, :critic_tomatometer, :description, :metascore,
                  :title, :user_tomatometer, :year  )

  LIST = []

  def initialize(movie_hash)
    movie_hash.each do |key, value|
      self.send( ( "#{key}=" ), value )
    end
    self
  end

  def self.create_list(movies_array)
    movies_array.each { |movie| LIST << new(movie) }
  end

  def self.all
    LIST
  end

end
