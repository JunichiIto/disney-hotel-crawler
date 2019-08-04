require 'test_helper'

class HotelPlanTest < ActiveSupport::TestCase
  test ".fetch_hotel_plan" do
    VCR.use_cassette('fetch_hotel_plan') do
      assert_difference ->{ HotelPlan.count } => 8 do
        HotelPlan.fetch_hotel_plan
      end
    end
  end
end
