require 'test_helper'

class ReportMailerTest < ActionMailer::TestCase
  test "daily_report" do
    mail = ReportMailer.daily_report
    assert_equal "Daily report", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
