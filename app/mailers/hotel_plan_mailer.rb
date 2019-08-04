class HotelPlanMailer < ApplicationMailer
  def notification(hotel_plans)
    @hotel_plans = hotel_plans
    subject = '新しいプランが見つかりました'
    to = 'jnchito@example.com'
    from = 'noreply@example.com'
    mail(to: to, from: from, subject: subject)
  end
end
