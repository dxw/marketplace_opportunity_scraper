# frozen_string_literal: true

module MarketplaceOpportunityScraper
  class Opportunity
    extend Utils

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

    class << self
      def all(type: nil, status: 'open')
        url = build_url(type, status)
        page = mechanize.get(url)
        opportunities = page.search('.search-result')

        opportunities.map { |o| opportunity_from_search_result(o) }
      end

      def find(id)
        opportunity_from_id(id)
      end

      def mechanize
        @@mechanize ||= Mechanize.new
      end

      private

      def opportunity_from_id(id)
        url = BASE_URL + '/digital-outcomes-and-specialists/opportunities/' + id.to_s
        page = mechanize.get(url)

        title = page.at('h1')

        attrs = {
          page: page,
          id: id,
          title: title.text.strip,
          url: url,
          buyer: page.at('.govuk-caption-l').text,
          location: text_from_label(page, 'Location'),
          published: date_from_label(page, 'Published'),
          question_deadline: date_from_label(page, 'Deadline for asking questions'),
          closing: date_from_label(page, 'Closing date for applications'),
          expected_start_date: date_from_label(page, 'Latest start date'),
          description: text_from_label(page, 'Summary of the work')
        }

        new(attrs)
      end

      def opportunity_from_search_result(element)
        title = element.at('.search-result-title')
        url = BASE_URL + title.at('a').attributes['href'].value

        opportunity_from_id(url.split('/').last.to_i)
      end
    end

    def budget
      text_from_label('Budget range')
    end

    def skills
      list = find_by_label('Essential skills and experience').search('li')
      list.map { |li| li.text.strip }
    end

    def find_by_label(label)
      self.class.send(:find_by_label, page, label)
    end

    def text_from_label(label)
      self.class.send(:text_from_label, page, label)
    end

    def status
      return 'open' if banner.nil?
      return 'cancelled' if banner.text =~ /cancelled/
      return 'awaiting' if banner.text =~ /closed for applications/

      'awarded'
    end

    def awarded_to
      return if banner.nil?

      text = banner.at('h2').text
      return unless text =~ /Awarded to/

      text.gsub('Awarded to ', '').strip
    end

    def page
      @page ||= @@mechanize.get(@url)
    end

    private

    def banner
      @banner ||= page.at('.banner-temporary-message-without-action')
    end
  end
end
