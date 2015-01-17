require 'rails_helper'

describe SearchOffer do
  context "Attributes" do
    it { should respond_to :uid }
    it { should respond_to :uid= }

    it { should respond_to :pub0 }
    it { should respond_to :pub0= }

    it { should respond_to :page }
    it { should respond_to :page= }
  end

  context "Validations" do
    it "validates presence of uid" do
      subject.uid = nil
      subject.valid?
      expect(subject.errors[:uid]).to eq ["can't be blank"]
    end

    it "validates presence of page" do
      subject.page = nil
      subject.valid?
      expect(subject.errors[:page]).to eq ["can't be blank"]
    end

    it "validates errors displayed by FyberApi::Offer" do
      allow(FyberApi::Offers).to receive(:fetch).and_raise("An invalid or missing user id (uid) was given as a parameter in the request.")

      subject.uid = "user"
      subject.page = 1

      subject.valid?

      expect(subject.errors[:base]).to eq ["An invalid or missing user id (uid) was given as a parameter in the request."]
    end
  end

  describe "#offers" do
    context "invalid search" do
      it "returns an empty array" do
        subject = SearchOffer.new(uid: "player1")

        expect(subject.offers).to be_empty
      end
    end

    context "valid search" do
      it "returns an array with offers" do
        response = File.read("spec/fixtures/offers.json")

        stub_request(:get, %r{http://api\.sponsorpay\.com/feed/v1/offers\.json.*}).to_return(
          body: response,
          headers: {
            'Content-Type' => 'application/json',
            'X-Sponsorpay-Response-Signature' => '39fbe82a4ec5ca968b3c5b484d382456b6fc5182',
            'X-Sponsorpay-Response-Code' => 'OK'
          }
        )

        subject = SearchOffer.new(uid: "player1", page: 1)

        expect(subject).to be_valid

        expect(subject.offers).to be_instance_of(Array)
        expect(subject.offers.count).to eq 30
        expect(subject.offers.first).to be_instance_of(Offer)
      end
    end
  end
end
