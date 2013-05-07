class AddUserNameToArtist < ActiveRecord::Migration
  def change
    add_column :artists, :user_name, :string
  end
end
