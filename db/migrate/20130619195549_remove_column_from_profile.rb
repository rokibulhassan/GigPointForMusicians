class RemoveColumnFromProfile < ActiveRecord::Migration
  def up
    remove_column :profiles, :profile_picture
    remove_column :profiles, :photo
  end

  def down
    add_column :profiles, :profile_picture, :string
    add_column :profiles, :photo, :string
  end
end
