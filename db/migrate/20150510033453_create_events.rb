class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :event_type
      t.string :end_reason_type
      t.integer :customer_id , limit: 8
      t.string :device_type
      t.integer :track_owner
      t.integer :station_id, limit: 8
      t.string :storefront_name
      t.string :cma_flag
      t.string :heat_seeker_flag

      t.timestamps null: false
    end
  end
end
