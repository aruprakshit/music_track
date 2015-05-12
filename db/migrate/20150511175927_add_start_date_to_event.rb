class AddStartDateToEvent < ActiveRecord::Migration
  def change
    add_column :events, :start_date, :date
    add_column :events, :event_start_time, :integer, limit: 8
    add_column :events, :event_end_time, :integer, limit: 8
  end
end
