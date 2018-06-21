
=begin
  TODO
  1. look for ways to make this shorter/faster
  2. split methods into public, private, and maybe protected
=end

class Scraper
  def self.scrape_list
    imdb = Nokogiri::HTML(open("https://www.imdb.com/movies-in-theaters"))
    movie_list = []

    imdb.css('div.sub-list')[0].css('div.list_item').each { |element|
      movie = {
        # cast: list_cast(element),
        description: strip_text( element.css('div.outline') ),
        # director: strip_text( element.css('div.txt-block a')[0] ),
        # duration: strip_text( element.css('time') ),
        # genre: list_genre(element),
        metascore: strip_text( element.css('div.rating_txt span')[0] ),
        # rated: list_rated(element),
        title: scrape_title( element.css('a')[1] )
      }
      movie_list.push(movie)
    }

    movie_list
  end

=begin
  def self.list_cast(node)
    if node.css('div.txt-block a')[1]
      node.css('div.txt-block a').collect { |star|
        star.text.strip
      }.drop(1).join(' | ')
    else
      ''
    end
  end
=end

  def self.strip_text(node)
    node ? node.text.strip : ''
  end

=begin
  def self.list_genre(node)
    if node.css('p.cert-runtime-genre span')[0]
      node.css('p.cert-runtime-genre span').collect { |genre|
        genre.text.strip
      }.join.gsub('|', ' | ')
    else
      ''
    end
  end

  def self.list_rated(node)
    if lr = node.css('img')[1]
      lr.attribute('title').value.strip
    else
      ''
    end
  end
=end

  def self.scrape_title(title_node)
    title_node ? title_node.text.strip.split(' (')[0] : ''
  end

=begin
  attributes to scrap if movie already exists (created from list), or modify
  whats scraped in the first place?
      1. (unique values)
      2. cast
      3. description
      4. rating
      5. title
=end
  def self.scrape_movie(film_name)
    rt = Nokogiri::HTML(open("https://rottentomatoes.com/m/#{film_name}"))

    film = {
      cast: movie_cast(rt),
      consensus: movie_consensus(rt),
      critic_tomatometer: strip_text( rt.css('div.critic-score')[0] ),
      description: strip_text( rt.css('div.movie_synopsis') ),
      director: strip_text( rt.css('li.meta-row div.meta-value')[2] ),
      duration: movie_duration(rt),
      genre: movie_genre(rt),
      rated: strip_text( rt.css('li.meta-row div.meta-value')[0] ),
      studio: movie_studio(rt),
      title: scrape_title( rt.css('h1.title')[1] ),
      user_tomatometer: user_tomatometer(rt),
      writer: strip_text( rt.css('li.meta-row div.meta-value')[3] ),
      year: strip_text(  rt.css('span.year')[0] )
    }
  end

  def self.movie_cast(page)
    with_role = []

    if page.css('div.cast-item span')[0]
      page.css('div.cast-item span').each_with_index { |value, key|
        star = value.text.strip

        if star[0..2] == 'as '
          with_role[-1] += " #{star}"
        else
          with_role << star
        end
      }

      with_role.join(' | ')
    else
      ''
    end
  end

  def self.movie_consensus(page)
    mc = page.css('p.critic_consensus')[0]

    if mc && !mc.text.include?('No consensus yet.')
      mc.text.split('Critics Consensus:')[1].strip
    else
      ''
    end
  end

  def self.movie_duration(page)
    time_1 = page.css('div.meta-value time')[1]

    if time_1 && time_1.text.include?('minutes')
      time_1.text.strip
    else
      time_2 = page.css('div.meta-value time')[2]

      if time_2 && time_2.text.include?('minutes')
        time_2.text.strip
      else
        ''
      end
    end
  end

  def self.movie_genre(page)
    if page.css('li.meta-row')[1].css('a')[0]
      page.css('li.meta-row')[1].css('a').collect { |type|
        type.text.strip
      }.join(' | ')
    else
      ''
    end
  end

  def self.movie_studio(page)
    meta_table = page.css('li.meta-row div.meta-value')

    if meta_table && meta_table[0]
      meta_table.each_with_index { |ele, index|
        if ele.text.include?('minutes')
          return meta_table[index + 1].text.strip
        end
      }
      ''
    else
      ''
    end
  end

  def self.user_tomatometer(page)
    score = page.css('div.meter-value span.superPageFontColor').text.strip
    context = page.css('div.meter-value div.superPageFontColor').text.strip

    unless score == '' || context == 'want to see'
      score
    else
      ''
    end
  end

end
