# frozen_string_literal: true

require "spec_helper"

describe MarketplaceOpportunityScraper::Opportunity, :vcr do
  describe "#all" do
    subject { described_class.all }
    let(:opportunity) { subject.first }

    it "returns all open opportunities" do
      expect(subject.first).to be_a(described_class)
      expect(subject.count).to eq(29)
    end

    it "gets the correct opportunity data" do
      expect(opportunity.id).to eq(12544)
      expect(opportunity.url).to eq("https://www.digitalmarketplace.service.gov.uk/digital-outcomes-and-specialists/opportunities/12544")
      expect(opportunity.title).to eq("Principal Developer/ Technical Lead - Law Enforcement and Security for Data Services & Analytics")
      expect(opportunity.buyer).to eq("Data Service and Analytics (DSA), Home Office")
      expect(opportunity.location).to eq("London")
      expect(opportunity.published).to eq(Date.parse("2020-06-17"))
      expect(opportunity.question_deadline).to eq(Date.parse("2020-06-24"))
      expect(opportunity.closing).to eq(Date.parse("2020-07-01"))
      expect(opportunity.expected_start_date).to eq(Date.parse("2020-07-13"))
      expect(opportunity.description).to match(/senior colleagues to design and build/)
    end

    context "when type is specified" do
      subject { described_class.all(type: "digital-outcomes") }
      let(:opportunity) { subject.first }

      it "returns the correct opportunities" do
        expect(subject.first).to be_a(described_class)
        expect(subject.count).to eq(15)
      end

      it "gets data that is not on the homepage" do
        expect(opportunity.budget).to match(/£16,000/)
        expect(opportunity.skills.count).to eq(9)
        expect(opportunity.skills.first).to eq("Possess demonstrable experience of conducting market testing, user research activities and outputs with a range of audiences and stakeholders.")
        expect(opportunity.skills.last).to eq("Demonstrate experience of presenting user-friendly research to different audiences, including those with low technical expertise.")
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
    subject { described_class.find(12500) }

    it "gets the correct opportunity data" do
      expect(subject.id).to eq(12500)
      expect(subject.url).to eq("https://www.digitalmarketplace.service.gov.uk/digital-outcomes-and-specialists/opportunities/12500")
      expect(subject.title).to eq("Repairs Online - Technical Alpha")
      expect(subject.buyer).to eq("City of Lincoln Council")
      expect(subject.location).to eq("No specific location, eg they can work remotely")
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
      let(:opportunity) { described_class.find(12543) }

      it { expect(status).to eq("open") }
    end

    context "when an opportunity is awaiting" do
      let(:opportunity) { described_class.find(12206) }

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
