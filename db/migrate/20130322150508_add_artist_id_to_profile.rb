class AddArtistIdToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :artist_id, :integer
  end
end
