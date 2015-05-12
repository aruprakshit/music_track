class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks, :id => false, :primary_key => :apple_id do |t|
      t.integer :apple_id, limit: 8
      t.string :artist
      t.string :label
      t.string :isrc
      t.string :vendor_id
      t.string :vendor_offer_code

      t.timestamps null: false
    end
    add_index :tracks, :label
  end
end
