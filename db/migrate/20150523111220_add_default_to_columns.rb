class AddDefaultToColumns < ActiveRecord::Migration
  def change
    change_column_default :events, :created_at, DateTime.now
    change_column_default :events, :updated_at, DateTime.now
    change_column_default :tracks, :created_at, DateTime.now
    change_column_default :tracks, :updated_at, DateTime.now
  end
end
