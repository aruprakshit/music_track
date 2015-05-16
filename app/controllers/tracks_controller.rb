require 'rake'

Rake::Task.clear
Rails.application.load_tasks

class TracksController < ApplicationController
  def fetch
    labels = params[:label].delete_if(&:blank?).map { |word| "'#{word}'" }.join(",")
    Rake::Task[ 'csv:export' ].reenable
    Rake::Task[ 'csv:export' ].invoke(params[:start_date].to_date, params[:end_date].to_date, labels )
    ReportMailer.daily_report(params[:email]).deliver_now
  end
end
