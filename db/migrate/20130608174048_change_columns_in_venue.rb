class ChangeColumnsInVenue < ActiveRecord::Migration
  def change
    rename_column :venues, :about, :description
    rename_column :venues, :latitude, :lat
    rename_column :venues, :longitude, :lng
  end
end
