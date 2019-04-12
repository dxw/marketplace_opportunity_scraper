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
      expected_start_date
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

    def self.all(type: nil, status: 'open')
      url = build_url(type, status)
      page = mechanize.get(url)
      opportunities = page.search('.search-result')

      opportunities.map { |o| opportunity_from_search_result(o) }
    end

    def self.build_url(type, status)
      check_type(type)
      check_status(status)
      url = BASE_URL + '/digital-outcomes-and-specialists/opportunities'
      h = { type: type, statusOpenClosed: status }.reject { |k,v| v.nil? }
      params = URI.encode_www_form(h)
      "#{url}?#{params}"
    end

    def self.find(id)
      opportunity_from_id(id)
    end

    def self.mechanize
      @@mechanize ||= Mechanize.new
    end

    private

    def self.check_params(param, type)
      return if param.nil?

      valid_array = send("valid_#{type}")
      raise(ArgumentError, "#{param} is not a valid #{type}. Must be one of #{valid_array.join(' ')}") unless valid_array.include?(param)
    end

    def self.check_type(type)
      check_params(type, 'types')
    end

    def self.check_status(status)
      check_params(status, 'statuses')
    end

    def self.valid_types
      %w[digital-outcomes digital-specialists user-research-participants]
    end

    def self.valid_statuses
      %w[open closed]
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
        published: date_from_label(page, 'Published'),
        question_deadline: date_from_label(page, 'Deadline for asking questions'),
        closing: date_from_label(page, 'Closing date for applications'),
        expected_start_date: date_from_label(page, 'Latest start date'),
        description: text_from_label(page, 'Summary of the work')
      }

      new(attrs)
    end

    def self.opportunity_from_search_result(element)
      title = element.at('.search-result-title')
      url = BASE_URL + title.at('a').attributes['href'].value

      opportunity_from_id(url.split('/').last.to_i)
    end

    def self.text_from_label(page, label)
      find_by_label(page, label).text.strip
    end

    def self.date_from_label(page, label)
      Date.parse(text_from_label(page, label)) rescue nil
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
