# frozen_string_literal: true

require 'spec_helper'

describe MarketplaceOpportunityScraper::Opportunity, :vcr do
  describe '#all' do
    subject { described_class.all }
    let(:opportunity) { subject.first }

    it 'returns all open opportunities' do
      expect(subject.first).to be_a(described_class)
      expect(subject.count).to eq(20)
    end

    it 'gets the correct opportunity data' do
      expect(opportunity.id).to eq(9482)
      expect(opportunity.url).to eq('https://www.digitalmarketplace.service.gov.uk/digital-outcomes-and-specialists/opportunities/9482')
      expect(opportunity.title).to eq('National Careers Service Digital Developments')
      expect(opportunity.buyer).to eq('Education and Skills Funding Agency')
      expect(opportunity.location).to eq('West Midlands')
      expect(opportunity.published).to eq(Date.parse('2019-04-12'))
      expect(opportunity.question_deadline).to eq(Date.parse('2019-04-19'))
      expect(opportunity.closing).to eq(Date.parse('2019-04-26'))
      expect(opportunity.expected_start_date).to eq(Date.parse('2019-06-03'))
      expect(opportunity.description).to match(/digital development services/)
    end

    it 'gets data that is not on the homepage' do
      expect(opportunity.budget).to match(/8.2 million/)
      expect(opportunity.skills.count).to eq(16)
      expect(opportunity.skills.first).to eq('Provide a multidisciplinary complete team able to run a digital development through to completion')
      expect(opportunity.skills.last).to eq('Knowledge and experience working with Browserstack and Selenium')
    end

    context 'when type is specified' do
      subject { described_class.all(type: 'digital-outcomes') }

      it 'returns the correct opportunities' do
        expect(subject.first).to be_a(described_class)
        expect(subject.count).to eq(14)
      end
    end

    context 'when an invalid type is specified' do
      subject { described_class.all(type: 'not-a-type') }

      it 'returns the correct opportunities' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'when status is specified' do
      subject { described_class.all(status: 'closed') }

      it 'returns the correct opportunities' do
        expect(subject.first).to be_a(described_class)
        expect(subject.count).to eq(100)
      end
    end

    context 'when an invalid status is specified' do
      subject { described_class.all(status: 'not-a-status') }

      it 'returns the correct opportunities' do
        expect { subject }.to raise_error(ArgumentError)
      end
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

  describe '#status' do
    let(:status) { opportunity.status }

    context 'when an opportunity is still open' do
      let(:opportunity) { described_class.find(9482) }

      it { expect(status).to eq('open') }
    end

    context 'when an opportunity is awaiting' do
      let(:opportunity) { described_class.find(9383) }

      it { expect(status).to eq('awaiting') }
    end

    context 'when an opportunity is cancelled' do
      let(:opportunity) { described_class.find(9242) }

      it { expect(status).to eq('cancelled') }
    end

    context 'when an opportunity has been awarded' do
      let(:opportunity) { described_class.find(9115) }

      it { expect(status).to eq('awarded') }
    end
  end

  describe '#awarded_to' do
    let(:awarded_to) { opportunity.awarded_to }

    context 'when an opportunity has been awarded' do
      let(:opportunity) { described_class.find(9115) }

      it { expect(awarded_to).to eq('Atkins Limited') }
    end

    context 'when an opportunity has not been awarded' do
      let(:opportunity) { described_class.find(9242) }

      it { expect(awarded_to).to eq(nil) }
    end

    context 'when an opportunity is still open' do
      let(:opportunity) { described_class.find(9482) }

      it { expect(awarded_to).to eq(nil) }
    end
  end
end
