class RemoveProfileIdFromVenue < ActiveRecord::Migration
  def up
    remove_column :venues, :profile_id
  end

  def down
    add_column :venues, :profile_id, :integer
  end
end
