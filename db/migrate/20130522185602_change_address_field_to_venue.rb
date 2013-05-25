class ChangeAddressFieldToVenue < ActiveRecord::Migration
  def change
    rename_column :venues, :address, :name
  end
end
