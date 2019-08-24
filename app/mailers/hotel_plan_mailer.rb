class HotelPlanMailer < ApplicationMailer
  def notification(hotel_plans)
    @hotel_plans = hotel_plans
    subject = '新しいプランが見つかりました'
    to = Settings.mail.to
    from = Settings.mail.from
    mail(to: to, from: from, subject: subject)
  end
end
