class Scraper
  # attr_accessor

  def initialize
    imdb = Nokogiri::HTML(open("https://www.imdb.com/movies-in-theaters"))

    imdb.css('div.list_item').each { |element|
      title = element.css('a')[1].text.strip
      description = element.css('div.outline').text.strip
      # TODO use collect then convert to string
      genre = element.css('p.cert-runtime-genre span')[0].text
      metascore = element.css('div.rating_txt span').text.strip
      # TODO use collect and ignore 0
      stars = element.css('div.txt-block a')[1].text.strip
      rating = element.css('img')[1].attribute('title').value if element.css('img')[1]
      director = element.css('div.txt-block a')[0].text.strip
    }


  end

end

#rt = Nokogiri::HTML(open("https://rottentomatoes.com/m/incredibles_2"))
#tester_2 = rt.css('div.movie_synopsis').text.strip
