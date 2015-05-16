require 'rake'

Rake::Task.clear
Rails.application.load_tasks

class TracksController < ApplicationController
  def fetch
    Rake::Task[ 'csv:export' ].reenable
    Rake::Task[ 'csv:export' ].invoke
    ReportMailer.daily_report(params[:email]).deliver_now
  end
end
