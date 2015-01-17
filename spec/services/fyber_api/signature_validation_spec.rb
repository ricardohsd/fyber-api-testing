require 'rails_helper'

describe FyberApi::SignatureValidation do
  describe "#valid?" do
    it "validates if signature is real" do
      response = "response"
      signature = 'e7ae29aa7a68b2f7a22603dfb4927fd6669fbbb2'

      subject = FyberApi::SignatureValidation.new(response, signature)

      expect(subject).to be_valid
    end

    it "raise error if signature isn't real" do
      response = File.read("spec/fixtures/offers.json")
      signature = '10e2e1a04e3c94298befb87e0e799507260c04e2'

      subject = FyberApi::SignatureValidation.new(response, signature)

      expect { subject.valid? }.to raise_error("Invalid response signature")
    end
  end
end
