
class Scraper
  
  def self.scrape_list
    imdb = Nokogiri::HTML(open("https://www.imdb.com/movies-in-theaters"))
    movie_list = []

    imdb.css('div.sub-list')[0].css('div.list_item').each do |element|
      movie = {
        description: strip_text( element.css('div.outline') ),
        metascore: strip_text( element.css('div.rating_txt span')[0] ),
        title: scrape_title( element.css('a')[1] )
      }
      movie_list.push(movie)
    end

    movie_list
  end

  def self.strip_text(node)
    node ? node.text.strip : ''
  end

  def self.scrape_title(title_node)
    title_node ? title_node.text.strip.split(' (')[0] : ''
  end

  def self.scrape_movie(film_name)
    rt = Nokogiri::HTML(open("https://rottentomatoes.com/m/#{film_name}"))

    film = {
      cast: movie_cast( rt.css('div.cast-item span') ),
      consensus: movie_consensus( rt.css('p.critic_consensus')[0] ),
      critic_tomatometer: strip_text( rt.css('div.critic-score')[0] ),
      description: strip_text( rt.css('div.movie_synopsis') ),
      director: strip_text( rt.css('li.meta-row div.meta-value')[2] ),
      duration: movie_duration( rt.css('div.meta-value time') ),
      genre: movie_genre( rt.css('li.meta-row')[1].css('a') ),
      rated: strip_text( rt.css('li.meta-row div.meta-value')[0] ),
      studio: movie_studio( rt.css('li.meta-row div.meta-value') ),
      title: scrape_title( rt.css('h1.title')[1] ),
      user_tomatometer: user_tomatometer( rt ),
      writer: strip_text( rt.css('li.meta-row div.meta-value')[3] ),
      year: strip_text( rt.css('span.year')[0] )
    }
  end

  def self.movie_cast(cast_node)
    with_role = []

    if cast_node[0]
      cast_node.each_with_index do |value, key|
        star = value.text.strip

        if star[0..2] == 'as '
          with_role[-1] += " #{star}"
        else
          with_role << star
        end
      end

      with_role.join(' | ')
    else
      ''
    end
  end

  def self.movie_consensus(consensus_node)
    if consensus_node && !consensus_node.text.include?('No consensus yet.')
      consensus_node.text.split('Critics Consensus:')[1].strip
    else
      ''
    end
  end

  def self.movie_duration(duration_node)
    if duration_node[1] && duration_node[1].text.include?('minutes')
      duration_node[1].text.strip
    else
      if duration_node[2] && duration_node[2].text.include?('minutes')
        duration_node[2].text.strip
      else
        ''
      end
    end
  end

  def self.movie_genre(genre_node)
    if genre_node[0]
      genre_node.collect do |type|
        type.text.strip
      end.join(' | ')
    else
      ''
    end
  end

  def self.movie_studio(studio_node)
    if studio_node && studio_node[0]
      studio_node.each_with_index do |ele, index|
        if ele.text.include?('minutes')
          return studio_node[index + 1].text.strip
        end
      end
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
