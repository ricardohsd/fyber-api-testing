require 'digest/sha1'

module FyberApi
  class HashKey
    def self.generate(*params)
      new(*params).generate
    end

    def initialize(params, digest = Digest::SHA1)
      self.params = params
      self.digest = digest
    end

    def generate
      digest.hexdigest concatenated_params
    end

    protected

    attr_accessor :params, :digest

    def concatenated_params
      params.map { |k, v| "#{k}=#{v}" }.push(api_key).join("&")
    end

    def api_key
      Rails.application.secrets.api_key
    end
  end
end
