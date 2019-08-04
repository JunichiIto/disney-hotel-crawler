task :hotel_plan_notification => :environment do
  HotelPlan.fetch_hotel_plan
end
