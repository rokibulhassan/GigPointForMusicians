class DropGigArtistTable < ActiveRecord::Migration
  def up
    drop_table :gig_artists
  end

  def down
    create_table :gig_artists do |t|
      t.integer :gig_id
      t.integer :artist_id

      t.timestamps
    end
  end
end
