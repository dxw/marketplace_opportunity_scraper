# frozen_string_literal: true

require "spec_helper"

describe MarketplaceOpportunityScraper::Opportunity, :vcr do
  describe "#all" do
    subject { described_class.all }
    let(:opportunity) { subject.first }

    it "returns all open opportunities" do
      expect(subject.first).to be_a(described_class)
      expect(subject.count).to eq(26)
    end

    it "gets the correct opportunity data" do
      expect(opportunity.id).to eq(11_371)
      expect(opportunity.url).to eq("https://www.digitalmarketplace.service.gov.uk/digital-outcomes-and-specialists/opportunities/11371")
      expect(opportunity.title).to eq("WP1845: Global Digital Marketplace procurement/ beneficial ownership transparency - discovery/ alpha")
      expect(opportunity.buyer).to eq("Government Digital Service (GDS, part of the Cabinet Office)/ Foreign & Commonwealth Office (FCO)")
      expect(opportunity.location).to eq("No specific location, eg they can work remotely")
      expect(opportunity.published).to eq(Date.parse("2019-12-09"))
      expect(opportunity.question_deadline).to eq(Date.parse("2019-12-16"))
      expect(opportunity.closing).to eq(Date.parse("2019-12-23"))
      expect(opportunity.expected_start_date).to eq(Date.parse("2020-02-10"))
      expect(opportunity.description).to match(/Building on work planned or underway/)
    end

    it "gets data that is not on the homepage" do
      expect(opportunity.budget).to match(/£312,000/)
      expect(opportunity.skills.count).to eq(5)
      expect(opportunity.skills.first).to eq("Technical knowledge of relevant data standards (OCDS and BODS).")
      expect(opportunity.skills.last).to match(/understanding of working with and/)
    end

    context "when type is specified" do
      subject { described_class.all(type: "digital-outcomes") }

      it "returns the correct opportunities" do
        expect(subject.first).to be_a(described_class)
        expect(subject.count).to eq(22)
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
        expect(subject.count).to eq(100)
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
    subject { described_class.find(9142) }

    it "gets the correct opportunity data" do
      expect(subject.id).to eq(9142)
      expect(subject.url).to eq("https://www.digitalmarketplace.service.gov.uk/digital-outcomes-and-specialists/opportunities/9142")
      expect(subject.title).to eq("Development of  an online electronic Research Application submission and review Portal (eRAP)")
      expect(subject.buyer).to eq("Clinical Practice Research Datalink (CPRD) - Medicines and Healthcare  products Regulatory Agency")
      expect(subject.location).to eq("London")
      expect(subject.published).to eq(Date.parse("2019-02-22"))
      expect(subject.question_deadline).to eq(Date.parse("2019-03-01"))
      expect(subject.closing).to eq(Date.parse("2019-03-08"))
      expect(subject.description).to match(/anonymised health care data/)
      expect(subject.budget).to match(/£100,000/)
      expect(subject.skills.count).to eq(10)
      expect(subject.skills.first).to eq("Proven experience building easy-to-use web-based applications")
      expect(subject.skills.last).to eq("Have availability of resources to be able to start as soon as possible")
    end
  end

  describe "#status" do
    let(:status) { opportunity.status }

    context "when an opportunity is still open" do
      let(:opportunity) { described_class.find(11_371) }

      it { expect(status).to eq("open") }
    end

    context "when an opportunity is awaiting" do
      let(:opportunity) { described_class.find(11_137) }

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
      let(:opportunity) { described_class.find(9482) }

      it { expect(awarded_to).to eq(nil) }
    end
  end
end
