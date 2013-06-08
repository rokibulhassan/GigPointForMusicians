class ChangeColumnInArtist < ActiveRecord::Migration
  def change
    rename_column :artists, :booking_contact, :booking
    rename_column :artists, :user_name, :username
  end
end
