module MarketplaceOpportunityScraper
  class Opportunity
    BASE_URL = 'https://www.digitalmarketplace.service.gov.uk/digital-outcomes-and-specialists/opportunities'
    ATTTIBUTES = %i[
      title
      buyer
      location
      published
      question_deadline
      closing
      description
    ]

    attr_reader *ATTTIBUTES

    def initialize(attrs)
      ATTTIBUTES.each do |a|
        instance_variable_set("@#{a}", attrs[a])
      end
    end

    def self.all
      url = BASE_URL + '?q=&statusOpenClosed=open'
      page = mechanize.get(url)
      opportunities = page.search('.search-result')

      opportunities.map { |o| opportunity_from_search_result(o) }
    end

    def self.opportunity_from_search_result(element)
      important_metadata = element.search('ul.search-result-important-metadata li')
      dates = element.search('ul.search-result-metadata')[1].search('li')

      attrs = {
        title: element.at('.search-result-title').text.strip,
        buyer: important_metadata[0].text.strip,
        location: important_metadata[1].text.strip,
        published: get_date(dates[0]),
        question_deadline: get_date(dates[1]),
        closing: get_date(dates[2]),
        description: element.at('.search-result-excerpt').text.strip
      }

      new(attrs)
    end

    def self.mechanize
      @@mechanize ||= Mechanize.new
    end

    private

    def self.get_date(date)
      DateTime.parse date.text.split(':').last
    end
  end
end