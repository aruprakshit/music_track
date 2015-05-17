class ReportMailerJob < ActiveJob::Base
  queue_as :default

  def perform(email)
    ReportMailer.daily_report(email).deliver_now
  end
end
