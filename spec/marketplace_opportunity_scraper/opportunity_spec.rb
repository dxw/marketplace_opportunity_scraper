# frozen_string_literal: true

require "spec_helper"

describe MarketplaceOpportunityScraper::Opportunity, :vcr do
  describe "#all" do
    subject { described_class.all }
    let(:opportunity) { subject.first }

    it "returns all open opportunities" do
      expect(subject.first).to be_a(described_class)
      expect(subject.count).to eq(27)
    end

    it "gets the correct opportunity data" do
      expect(opportunity.id).to eq(13198)
      expect(opportunity.url).to eq("https://www.digitalmarketplace.service.gov.uk/digital-outcomes-and-specialists/opportunities/13198")
      expect(opportunity.title).to eq("CCT934-MOD FHRS Delivery Partner for Oracle SaaS & PaaS Technical, Business & Service Change")
      expect(opportunity.buyer).to eq("Ministry of Defence")
      expect(opportunity.location).to eq("South West England")
      expect(opportunity.published).to eq(Date.parse("2020-09-30"))
      expect(opportunity.question_deadline).to eq(Date.parse("2020-10-07"))
      expect(opportunity.closing).to eq(Date.parse("2020-10-14"))
      expect(opportunity.expected_start_date).to eq(Date.parse("2020-12-14"))
      expect(opportunity.description).to match(/Business and Service Change/)
    end

    context "when type is specified" do
      subject { described_class.all(type: "digital-outcomes") }
      let(:opportunity) { subject.first }

      it "returns the correct opportunities" do
        expect(subject.first).to be_a(described_class)
        expect(subject.count).to eq(20)
      end

      it "gets data that is not on the homepage" do
        expect(opportunity.budget).to match(/£5,280,319/)
        expect(opportunity.skills.count).to eq(17)
        expect(opportunity.skills.first).to eq("Experience, within the last 4 years, of engineering Oracle based SaaS/PaaS solutions that align to the business requirements. (5pts)")
        expect(opportunity.skills.last).to eq("Experience of learning from others and benchmarking to improve the delivery of the project outputs/outcomes. (4pts)")
      end
    end

    context "when an invalid type is specified" do
      subject { described_class.all(type: "not-a-type") }

      it "returns the correct opportunities" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "when status is specified" do
      subject { described_class.all(status: "closed") }

      it "returns the correct opportunities" do
        expect(subject.first).to be_a(described_class)
        expect(subject.count).to eq(30)
      end
    end

    context "when an invalid status is specified" do
      subject { described_class.all(status: "not-a-status") }

      it "returns the correct opportunities" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#find" do
    subject { described_class.find(12500) }

    it "gets the correct opportunity data" do
      expect(subject.id).to eq(12500)
      expect(subject.url).to eq("https://www.digitalmarketplace.service.gov.uk/digital-outcomes-and-specialists/opportunities/12500")
      expect(subject.title).to eq("Repairs Online - Technical Alpha")
      expect(subject.buyer).to eq("City of Lincoln Council")
      expect(subject.location).to eq("No specific location, for example they can work remotely")
      expect(subject.published).to eq(Date.parse("2020-06-15"))
      expect(subject.question_deadline).to eq(Date.parse("2020-06-22"))
      expect(subject.closing).to eq(Date.parse("2020-06-29"))
      expect(subject.description).to match(/common service pattern for end-to-end housing repairs/)
      expect(subject.budget).to match(/£45,000/)
      expect(subject.skills.count).to eq(5)
      expect(subject.skills.first).to eq("Technical experience of development and integration options")
      expect(subject.skills.last).to eq("Share their work freely and openly with the partner organisations and the wider community")
    end
  end

  describe "#status" do
    let(:status) { opportunity.status }

    context "when an opportunity is still open" do
      let(:opportunity) { described_class.find(13198) }

      it { expect(status).to eq("open") }
    end

    context "when an opportunity is awaiting" do
      let(:opportunity) { described_class.find(13104) }

      it { expect(status).to eq("awaiting") }
    end

    context "when an opportunity is cancelled" do
      let(:opportunity) { described_class.find(11_036) }

      it { expect(status).to eq("cancelled") }
    end

    context "when an opportunity has been awarded" do
      let(:opportunity) { described_class.find(9115) }

      it { expect(status).to eq("awarded") }
    end
  end

  describe "#awarded_to" do
    let(:awarded_to) { opportunity.awarded_to }

    context "when an opportunity has been awarded" do
      let(:opportunity) { described_class.find(9115) }

      it { expect(awarded_to).to eq("Atkins Limited") }
    end

    context "when an opportunity has not been awarded" do
      let(:opportunity) { described_class.find(9242) }

      it { expect(awarded_to).to eq(nil) }
    end

    context "when an opportunity is still open" do
      let(:opportunity) { described_class.find(13198) }

      it { expect(awarded_to).to eq(nil) }
    end
  end
end
