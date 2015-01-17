class OffersController < ApplicationController
  def new
    @search_offer = SearchOffer.new
  end

  def search
    @search_offer = SearchOffer.new(search_params)

    unless @search_offer.valid?
      render :new
    end
  end

  private

  def search_params
    params.require(:search_offer).permit(
      :uid, :pub0, :page
    )
  end
end
