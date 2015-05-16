class ReportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_mailer.daily_report.subject
  #
  def daily_report(to_email)
    attachments['data.csv'] = File.read(Rails.root.join("tmp/report/data.csv"))
    mail to: to_email, subject: 'Your daily top 50 events report'
  end
end
