module FyberApi
  class Offers < Base
    def self.fetch(*params)
      new(*params).fetch
    end

    def initialize(params)
      @params = params
    end

    def fetch
      Rails.logger.info "GET #{endpoint}?#{request_params.to_query}"

      begin
        result = RestClient.get endpoint, { params: request_params }
        response = JSON.parse(result)

        SignatureValidation.valid?(result.body, result.headers[:x_sponsorpay_response_signature])

        if response["code"] == NO_CONTENT
          response = []
        elsif response["code"] != OK_CODE
          raise ApiError.new(response["message"])
        end
      rescue SocketError, RestClient::ResourceNotFound
        raise ApiError.new("Not found")
      rescue => e
        raise ApiError.new(e.message)
      end

      response
    end

    protected

    def endpoint
      super + "offers.json"
    end

    def request_params
      base_params.reverse_merge(hashkey: hash_key)
    end

    def hash_key
      HashKey.generate(base_params)
    end

    def base_params
      @base_params ||= {
        appid: secrets.appid,
        format: secrets.format,
        locale: secrets.locale,
        ip: secrets.ip,
        device: secrets.device_id,
        offer_types: secrets.offer_types,
        os_version: secrets.os_version,
        timestamp: Time.now.to_i
      }.reverse_merge(@params).sort.to_h
    end

    def secrets
      @secrets ||= Rails.application.secrets
    end
  end
end
