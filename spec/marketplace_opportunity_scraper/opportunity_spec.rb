require 'spec_helper'

describe MarketplaceOpportunityScraper::Opportunity, :vcr do

  describe '#all' do
    subject { described_class.all }

    it 'returns all open opportunities' do
      expect(subject.first).to be_a(described_class)
      expect(subject.count).to eq(37)
    end

    it 'gets the correct opportunity data' do
      opportunity = subject.first

      expect(opportunity.id).to eq(9142)
      expect(opportunity.url).to eq('https://www.digitalmarketplace.service.gov.uk/digital-outcomes-and-specialists/opportunities/9142')
      expect(opportunity.title).to eq('Development of  an online electronic Research Application submission and review Portal (eRAP)')
      expect(opportunity.buyer).to eq('Clinical Practice Research Datalink (CPRD) - Medicines and Healthcare  products Regulatory Agency')
      expect(opportunity.location).to eq('London')
      expect(opportunity.published).to eq(Date.parse('2019-02-22'))
      expect(opportunity.question_deadline).to eq(Date.parse('2019-03-01'))
      expect(opportunity.closing).to eq(Date.parse('2019-03-08'))
      expect(opportunity.description).to match(/anonymised health care data/)
    end
  end

  describe '#find' do
    subject { described_class.find(9142) }

    it 'gets the correct opportunity data' do
      expect(subject.id).to eq(9142)
      expect(subject.url).to eq('https://www.digitalmarketplace.service.gov.uk/digital-outcomes-and-specialists/opportunities/9142')
      expect(subject.title).to eq('Development of  an online electronic Research Application submission and review Portal (eRAP)')
      expect(subject.buyer).to eq('Clinical Practice Research Datalink (CPRD) - Medicines and Healthcare  products Regulatory Agency')
      expect(subject.location).to eq('London')
      expect(subject.published).to eq(Date.parse('2019-02-22'))
      expect(subject.question_deadline).to eq(Date.parse('2019-03-01'))
      expect(subject.closing).to eq(Date.parse('2019-03-08'))
      expect(subject.description).to match(/anonymised health care data/)
    end
  end

end
