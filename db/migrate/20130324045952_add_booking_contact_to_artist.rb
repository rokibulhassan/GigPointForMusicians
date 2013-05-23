class AddBookingContactToArtist < ActiveRecord::Migration
  def change
    add_column :artists, :booking_contact, :string
  end
end
