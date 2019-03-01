require 'spec_helper'

describe MarketplaceOpportunityScraper::Opportunity, :vcr do

  describe '#all' do
    subject { described_class.all }
    let(:opportunity) { subject.first }

    it 'returns all open opportunities' do
      expect(subject.first).to be_a(described_class)
      expect(subject.count).to eq(37)
    end

    it 'gets the correct opportunity data' do
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

    it 'gets data that is not on the homepage' do
      expect(opportunity.budget).to match(/£100,000/)
      expect(opportunity.skills.count).to eq(10)
      expect(opportunity.skills.first).to eq('Proven experience building easy-to-use web-based applications')
      expect(opportunity.skills.last).to eq('Have availability of resources to be able to start as soon as possible')
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
      expect(subject.budget).to match(/£100,000/)
      expect(subject.skills.count).to eq(10)
      expect(subject.skills.first).to eq('Proven experience building easy-to-use web-based applications')
      expect(subject.skills.last).to eq('Have availability of resources to be able to start as soon as possible')
    end
  end

end
