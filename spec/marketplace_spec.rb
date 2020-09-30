require "spec_helper"

describe "https://www.digitalmarketplace.service.gov.uk", :smoke_test do
  describe "/digital-outcomes-and-specialists/opportunities" do
    it "has a list of opportunities in the expected format" do
      opportunities = MarketplaceOpportunityScraper::Opportunity.all

      expect(opportunities.count).to be > 0
    end
  end

  describe "/digital-outcomes-and-specialists/opportunities/12500" do
    it "gets all the relevant fields" do
      opportunity = MarketplaceOpportunityScraper::Opportunity.find(12500)

      expect(opportunity.id).to_not be_nil
      expect(opportunity.url).to_not be_nil
      expect(opportunity.title).to_not be_nil
      expect(opportunity.buyer).to_not be_nil
      expect(opportunity.location).to_not be_nil
      expect(opportunity.published).to_not be_nil
      expect(opportunity.question_deadline).to_not be_nil
      expect(opportunity.closing).to_not be_nil
      expect(opportunity.description).to_not be_nil
      expect(opportunity.budget).to_not be_nil
      expect(opportunity.skills.count).to_not be_nil
      expect(opportunity.skills.first).to_not be_nil
      expect(opportunity.skills.last).to_not be_nil
    end
  end

  describe "/digital-outcomes-and-specialists/opportunities/9115" do
    it "still returns the status" do
      opportunity = MarketplaceOpportunityScraper::Opportunity.find(9115)

      expect(opportunity.status).to eq("awarded")
    end
  end
end
