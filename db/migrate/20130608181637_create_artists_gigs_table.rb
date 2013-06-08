class CreateArtistsGigsTable < ActiveRecord::Migration
  def change
    create_table "artists_gigs", :id => false, :force => true do |t|
      t.integer "artist_id"
      t.integer "gig_id"
    end
  end
end
