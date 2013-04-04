class AddExtraInfoAndOthersAndLngAndLatToGigs < ActiveRecord::Migration
  def change
    add_column :gigs, :extra_info, :text
    add_column :gigs, :latitude,  :float #you can change the name, see wiki
    add_column :gigs, :longitude, :float #you can change the name, see wiki
    add_column :gigs, :gmaps, :boolean #not mandatory, see wiki
    add_column :gigs, :others, :string
  end
end
