# MOTW

The Movies Opening This Week rubygem is a CLI application to look up a list of new releases for the next 7 days and to lookup movies in general.
It scrapes data from IMDB to create the weeks list and uses rotten tomatoes for pulling data on a specific movie.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'MOTW'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install MOTW

## Usage

To launch the application browse to the root directory 'MOTW' in your commandline, and enter ./bin/motw.
This will launch the software and from this point on follow the on screen directions.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BrennanFulmer/MOTW_Gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MOTW project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/BrennanFulmer/MOTW_Gem/blob/master/CODE_OF_CONDUCT.md).
