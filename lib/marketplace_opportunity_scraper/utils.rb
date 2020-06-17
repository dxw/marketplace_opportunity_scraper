# frozen_string_literal: true

module MarketplaceOpportunityScraper
  module Utils
    private

    def build_url(type, status)
      check_type(type)
      check_status(status)
      url = BASE_URL + "/digital-outcomes-and-specialists/opportunities"
      h = {lot: type, statusOpenClosed: status}.reject { |_k, v| v.nil? }
      params = URI.encode_www_form(h)
      "#{url}?#{params}"
    end

    def check_params(param, type)
      return if param.nil?

      valid_array = send("valid_#{type}")
      raise(ArgumentError, "#{param} is not a valid #{type}. Must be one of #{valid_array.join(" ")}") unless valid_array.include?(param)
    end

    def check_type(type)
      check_params(type, "types")
    end

    def check_status(status)
      check_params(status, "statuses")
    end

    def valid_types
      %w[digital-outcomes digital-specialists user-research-participants]
    end

    def valid_statuses
      %w[open closed]
    end

    def text_from_label(page, label)
      find_by_label(page, label).text.strip
    end

    def date_from_label(page, label)
      Date.parse(text_from_label(page, label))
    rescue ArgumentError
      nil
    end

    def find_by_label(page, label)
      selector = "//dt[normalize-space()='#{label}']/../dd"
      page.search(selector)
    end
  end
end
