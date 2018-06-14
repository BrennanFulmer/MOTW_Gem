class Scraper
  # attr_accessor

  def initialize
=begin
    imdb = Nokogiri::HTML(open("https://www.imdb.com/movies-in-theaters"))

    imdb.css('div.list_item').each { |node|
      title = node.css('a')[1].text.strip if node.css('a')[1]
      description = node.css('div.outline').text.strip if node.css('div.outline')
      # TODO use collect then convert to string
      genre = node.css('p.cert-runtime-genre span')[0].text.strip if node.css('p.cert-runtime-genre span')[0]
      metascore = node.css('div.rating_txt span').text.strip if node.css('div.rating_txt span')
      # TODO use collect then convert to string and ignore 0
      stars = node.css('div.txt-block a')[1].text.strip if node.css('div.txt-block a')[1]
      rating = node.css('img')[1].attribute('title').value if node.css('img')[1]
      director = node.css('div.txt-block a')[0].text.strip if node.css('div.txt-block a')[0]
      duration = node.css('time').text.strip if node.css('time')
      binding.pry
    }
=end

#=begin
    rt = Nokogiri::HTML(open("https://rottentomatoes.com/m/incredibles_2"))
    tester_2 = rt.css('div.movie_synopsis').text.strip
#=end

  end

end
