# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marketplace_opportunity_scraper/version'

Gem::Specification.new do |spec|
  spec.name          = 'marketplace_opportunity_scraper'
  spec.version       = MarketplaceOpportunityScraper::VERSION
  spec.authors       = ['Stuart Harrison']
  spec.email         = ['stuart@dxw.com']

  spec.summary       = 'A Ruby gem that fetches the latest opportunities from the Gov.uk Digital Marketplace (https://www.digitalmarketplace.service.gov.uk/) '
  spec.homepage      = 'https://github.com/dxw/marketplace_opportunity_scraper'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'pry', '~> 0.12.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.63'
  spec.add_development_dependency 'vcr', '~> 4.0'
  spec.add_development_dependency 'webmock', '~> 3.5'

  spec.add_dependency 'mechanize', '~> 2.7'
end
