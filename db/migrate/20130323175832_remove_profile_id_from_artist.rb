class RemoveProfileIdFromArtist < ActiveRecord::Migration
  def up
    remove_column :artists, :profile_id
  end

  def down
  end
end
