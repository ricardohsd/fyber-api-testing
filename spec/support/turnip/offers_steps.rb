module Turnip
  module OfferSteps
    step "I don't fill the search form" do
      visit root_path

      click_on "Search offers"
    end

    step "I should see the errors" do
      expect(page).to have_content "2 errors prohibited this search from being made:"

      expect(page).to have_content "Uid can't be blank"
      expect(page).to have_content "Page can't be blank"
    end

    step "I fill the search form with the correct params" do
      visit root_path

      response = File.read("spec/fixtures/offers.json")

      stub_request(:get, %r{http://api\.sponsorpay\.com/feed/v1/offers\.json.*}).to_return(
        body: response,
        headers: {
          'Content-Type' => 'application/json',
          'X-Sponsorpay-Response-Signature' => '39fbe82a4ec5ca968b3c5b484d382456b6fc5182',
          'X-Sponsorpay-Response-Code' => 'OK'
        }
      )

      fill_in 'Uid', with: "player1"
      fill_in 'Page', with: "1"

      click_on "Search offers"
    end

    step "I should see the offers" do
      expect(page).to have_css(".offers ul li", count: 30)

      expect(page).to have_link "New search"
      expect(page).to have_content "Katalog Kiosk"
    end
  end
end

RSpec.configure do |c|
  c.include Turnip::OfferSteps
end
