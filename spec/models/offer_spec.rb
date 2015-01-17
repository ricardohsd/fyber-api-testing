require 'rails_helper'

describe Offer do
  context "Attributes" do
    it { should respond_to :title }
    it { should respond_to :title= }

    it { should respond_to :payout }
    it { should respond_to :payout= }

    it { should respond_to :thumbnail }
    it { should respond_to :thumbnail= }
  end
end
