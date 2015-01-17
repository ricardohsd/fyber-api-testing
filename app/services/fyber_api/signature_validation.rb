module FyberApi
  class SignatureValidation
    class ApiSignatureError < Exception; end

    def self.valid?(*attributes)
      new(*attributes).valid?
    end

    def initialize(body, signature)
      self.body = body
      self.signature = signature
    end

    def valid?
      return true if digest == signature

      raise ApiSignatureError.new("Invalid response signature")
    end

    protected

    attr_accessor :body, :signature

    def digest
      Digest::SHA1.hexdigest("#{body}#{api_key}")
    end

    def api_key
      Rails.application.secrets.api_key
    end
  end
end
