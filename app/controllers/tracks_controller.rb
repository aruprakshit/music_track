class TracksController < ApplicationController
  def fetch
    ReportMailer.daily_report(params[:email]).deliver_now
  end
end
