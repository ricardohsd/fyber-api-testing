require 'rails_helper'

describe FyberApi::Offers do
  describe "#fetch" do
    context "valid request" do
      it "returns json with the response" do
        response = File.read("spec/fixtures/offers.json")

        stub_request(:get, %r{http://api\.sponsorpay\.com/feed/v1/offers\.json.*}).to_return(
          body: response,
          headers: {
            'Content-Type' => 'application/json',
            'X-Sponsorpay-Response-Signature' => '39fbe82a4ec5ca968b3c5b484d382456b6fc5182',
            'X-Sponsorpay-Response-Code' => 'OK'
          }
        )

        subject = FyberApi::Offers.new(
          uid: "player1",
          pub0: nil,
          page: "1"
        )

        expect(subject.fetch).to eq JSON.parse(response)
      end
    end

    context "invalid requests" do
      it "raise error when api returns an error" do
        response = File.read("spec/fixtures/invalid_offers.json")

        stub_request(:get, %r{http://api\.sponsorpay\.com/feed/v1/offers\.json.*}).to_return(
          body: response,
          headers: {
            'Content-Type' => 'application/json',
            'X-Sponsorpay-Response-Signature' => 'a4c97b851e8bc8ad6099eb6c8b95e44db92263b9',
            'X-Sponsorpay-Response-Code' => 'OK'
          }
        )

        subject = FyberApi::Offers.new(
          uid: nil,
          pub0: nil,
          page: "1"
        )

        expect { subject.fetch }.to raise_error("An invalid user id (uid) was given as a parameter in the request.")
      end

      it "raise 'Not found' when endpoint is not found" do
        stub_request(:get, %r{http://api\.sponsorpay\.com/feed/v1/offers\.json.*})

        allow(RestClient).to receive(:get).and_raise(RestClient::ResourceNotFound)

        subject = FyberApi::Offers.new(
          uid: "player1",
          pub0: nil,
          page: "1"
        )

        expect { subject.fetch }.to raise_error("Not found")
      end
    end
  end
end
