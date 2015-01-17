module FyberApi
  class Base
    class ApiError < Exception; end

    OK_CODE = "OK"
    NO_CONTENT = "NO_CONTENT"

    protected

    def endpoint
      "http://api.sponsorpay.com/feed/v1/"
    end
  end
end
