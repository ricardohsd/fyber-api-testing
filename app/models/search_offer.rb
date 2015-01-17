class SearchOffer
  include ActiveModel::Model

  attr_accessor :uid, :pub0, :page

  validates :uid, :page, presence: true
  validate :api_request_response

  def offers
    return [] unless valid?

    @offers ||= @response.map do |offer|
      Offer.new(
        title: offer["title"],
        payout: offer["payout"],
        thumbnail: offer["thumbnail"]["lowres"]
      )
    end
  end

  private

  def api_request_response
    return if uid.blank? || page.blank?

    begin
      @response = fetch_api["offers"]
    rescue Exception => e
      errors.add(:base, e.message)
    end
  end

  def fetch_api
    @api ||= FyberApi::Offers.fetch(
      uid: self.uid,
      pub0: self.pub0,
      page: self.page
    )
  end
end
