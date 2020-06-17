[![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fdxw%2Fmarketplace_opportunity_scraper%2Fbadge&style=flat)](https://actions-badge.atrox.dev/dxw/marketplace_opportunity_scraper/goto)
[![Gem Version](http://img.shields.io/gem/v/marketplace_opportunity_scraper.svg?style=flat-square)](https://rubygems.org/gems/marketplace_opportunity_scraper)
[![License](http://img.shields.io/:license-mit-blue.svg)](https://mit-license.org/)

# Marketplace Opportunity Scraper

A Ruby gem that fetches the latest opportunities from the [Gov.uk Digital Marketplace](https://www.digitalmarketplace.service.gov.uk/).

Inspired by Convivio's [Digital Marketplace Scraper](https://github.com/ConvivioTeam/digital-marketplace-scraper)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'marketplace_opportunity_scraper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install marketplace_opportunity_scraper

You can then fetch the latest opportunities as follows:

```ruby
require 'marketplace_opportunity_scraper'

opportunities = MarketplaceOpportunityScraper::Opportunity.all

opportunities.each do |o|
  o.id # An opportunity's ID
  o.url # The url of the opportunity
  o.title # The title of the opportunity
  o.buyer # The name of the client organisation
  o.location # Where the client is located
  o.published # When the opportunity was published
  o.question_deadline # Deadline for questions
  o.closing # Closing date
  o.description # Description of the opportunity
  o.budget # The budget
  o.skills # An array of required skills
end
```

Or you can get opportunities with a specific type (`digital-outcomes`, `digital-specialists` or `user-research-participants`):

```ruby
opportunities = MarketplaceOpportunityScraper::Opportunity.all(type: 'digital-outcomes')
```

By default, the scraper gets only open opportunities, but you can get closed ones too:

```ruby
opportunities = MarketplaceOpportunityScraper::Opportunity.all(status: 'closed')
```

You can also get an opportunity by its ID:

```ruby
require 'marketplace_opportunity_scraper'

opportunity = MarketplaceOpportunityScraper::Opportunity.find(123)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dxw/marketplace_opportunity_scraper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MarketplaceOpportunityScraper project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dxw/marketplace_opportunity_scraper/blob/master/CODE_OF_CONDUCT.md).
