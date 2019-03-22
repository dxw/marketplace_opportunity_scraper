# frozen_string_literal: true

module MarketplaceOpportunityScraper
  class Opportunity
    BASE_URL = 'https://www.digitalmarketplace.service.gov.uk'
    ATTRIBUTES = %i[
      id
      url
      title
      buyer
      location
      published
      question_deadline
      closing
      description
    ].freeze

    attr_reader *ATTRIBUTES

    def initialize(attrs)
      ATTRIBUTES.each do |a|
        instance_variable_set("@#{a}", attrs[a])
      end
      @page = attrs[:page]
    end

    def budget
      text_from_label('Budget range')
    end

    def skills
      list = find_by_label('Essential skills and experience').search('li')
      list.map { |li| li.text.strip }
    end

    def self.all(type = nil)
      check_type(type)
      url = BASE_URL + '/digital-outcomes-and-specialists/opportunities?q=&statusOpenClosed=open'
      url += "&lot=#{type}" unless type.nil?
      page = mechanize.get(url)
      opportunities = page.search('.search-result')

      opportunities.map { |o| opportunity_from_search_result(o) }
    end

    def self.find(id)
      opportunity_from_id(id)
    end

    def self.mechanize
      @@mechanize ||= Mechanize.new
    end

    private

    def self.check_type(type)
      return if type.nil?
      raise(ArgumentError, "#{type} is not a valid type. Must be one of #{valid_types.join(' ')}") unless valid_types.include?(type)
    end

    def self.valid_types
      ['digital-outcomes', 'digital-specialists', 'user-research-participants']
    end

    def self.get_date(date)
      Date.parse date.text.split(':').last
    end

    def self.opportunity_from_id(id)
      url = BASE_URL + '/digital-outcomes-and-specialists/opportunities/' + id.to_s
      page = mechanize.get(url)

      title = page.at('h1')

      attrs = {
        page: page,
        id: id,
        title: title.text.strip,
        url: url,
        buyer: page.at('.context').text,
        location: text_from_label(page, 'Location'),
        published: Date.parse(text_from_label(page, 'Published')),
        question_deadline: Date.parse(text_from_label(page, 'Deadline for asking questions')),
        closing: Date.parse(text_from_label(page, 'Closing date for applications')),
        description: text_from_label(page, 'Summary of the work')
      }

      new(attrs)
    end

    def self.opportunity_from_search_result(element)
      title = element.at('.search-result-title')
      important_metadata = element.search('ul.search-result-important-metadata li')
      dates = element.search('ul.search-result-metadata')[1].search('li')
      url = BASE_URL + title.at('a').attributes['href'].value

      attrs = {
        id: url.split('/').last.to_i,
        title: title.text.strip,
        url: url,
        buyer: important_metadata[0].text.strip,
        location: important_metadata[1].text.strip,
        published: get_date(dates[0]),
        question_deadline: get_date(dates[1]),
        closing: get_date(dates[2]),
        description: element.at('.search-result-excerpt').text.strip
      }

      new(attrs)
    end

    def self.text_from_label(page, label)
      find_by_label(page, label).text.strip
    end

    def self.find_by_label(page, label)
      selector = "//td[@class='summary-item-field-first']/span[text()='#{label}']/../../td[@class='summary-item-field']"
      page.search(selector)
    end

    def find_by_label(label)
      self.class.send(:find_by_label, page, label)
    end

    def text_from_label(label)
      self.class.send(:text_from_label, page, label)
    end

    def page
      @page ||= @@mechanize.get(@url)
    end
  end
end
