class CreateGigArtists < ActiveRecord::Migration
  def change
    create_table :gig_artists do |t|
      t.integer :gig_id
      t.integer :artist_id

      t.timestamps
    end
  end
end
