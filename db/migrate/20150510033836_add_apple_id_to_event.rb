class AddAppleIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :apple_id, :integer, limit: 8
    add_index :events, :apple_id
  end
end
