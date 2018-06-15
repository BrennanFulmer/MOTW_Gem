class Scraper

  def self.johnra(element)
    if element.css('p.cert-runtime-genre span')[0]
      element.css('p.cert-runtime-genre span').collect { |genre|
        genre.text.strip
      }.join.gsub('|', ' | ')
    end
  end

  def self.cast(element)
    if element.css('div.txt-block a')[1]
      element.css('div.txt-block a').collect { |star|
        star.text.strip
      }.drop(1).join(' | ')
    end
  end

  def self.scrape_list
    imdb = Nokogiri::HTML(open("https://www.imdb.com/movies-in-theaters"))
    movie_list = []

    imdb.css('div.list_item').each { |node|
      movie = {
        title: if a = node.css('a')[1] then a.text.strip.split(' (')[0] end,
        description: if b = node.css('div.outline') then b.text.strip end,
        genre: johnra(node),
        metascore: if c = node.css('div.rating_txt span') then c.text.strip end,
        stars: cast(node),
        rating: if d = node.css('img')[1] then d.attribute('title').value.strip end,
        director: if e = node.css('div.txt-block a')[0] then e.text.strip end,
        duration: if f = node.css('time') then f.text.strip end
      }
      movie[:rating] = '' unless movie[:rating]
      movie_list.push(movie)
    }
    movie_list
  end

  def self.scrape_movie(search_term)
    search = 'incredibles_2'
    rt = Nokogiri::HTML(open('https://rottentomatoes.com/m/' + "#{search}"))

    title = rt.css('h1.title')[0].text.strip if rt.css('h1.title')[0]
    description = rt.css('div.movie_synopsis').text.strip if rt.css('div.movie_synopsis')
      # TODO use collect then convert to string
      genre = rt.css('div.meta-value a')[0].text.strip if rt.css('div.meta-value a')[0]
    critic_tomatometer = rt.css('div.critic-score')[0].text.strip if rt.css('div.critic-score')[0]
    user_tomatometer = rt.css('div.audience-score span.superPageFontColor').text.strip if rt.css('div.audience-score span.superPageFontColor')
      # TODO use collect then convert to string
      stars = rt.css('div.cast-item span')[0].text.strip if rt.css('div.cast-item span')[0]
      role = rt.css('div.cast-item span')[1].text.strip if rt.css('div.cast-item span')[1]
    rating = rt.css('li.meta-row div.meta-value')[0].text.strip if rt.css('li.meta-row div.meta-value')[0]
    director = rt.css('li.meta-row div.meta-value')[2].text.strip if rt.css('li.meta-row div.meta-value')[2]
      # if the movie is available on DVD its rt.css('div.meta-value time')[2].text.strip
      duration = rt.css('div.meta-value time')[1].text.strip if rt.css('div.meta-value time')[1]
    writer = rt.css('li.meta-row div.meta-value')[3].text.strip if rt.css('li.meta-row div.meta-value')[3]
      # if the movie is available on DVD its rt.css('li.meta-row div.meta-value')[7].text.strip
      studio = rt.css('li.meta-row div.meta-value')[6].text.strip if rt.css('li.meta-row div.meta-value')[6]
    consensus = rt.css('p.critic_consensus')[0].text.strip
    year = rt.css('span.year')[0].text.strip if rt.css('span.year')[0]
  end

end
