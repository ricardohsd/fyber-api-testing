require 'rails_helper'

describe FyberApi::HashKey do
  describe "#generate" do
    it "should generate hash key with the given params" do
      params = { b: 1, a: 2, d: 3, c: 4 }
      api_key = Rails.application.secrets.api_key
      concatenated_params = "b=1&a=2&d=3&c=4&#{api_key}"
      hash_key = double(:hash_key)

      sha1 = double(:sha1)

      subject = FyberApi::HashKey.new(params, sha1)

      allow(sha1).to receive(:hexdigest).with(concatenated_params).and_return(hash_key)

      expect(subject.generate).to eq hash_key
    end
  end
end
