class ChangeLngAndLatAttributesInVenue < ActiveRecord::Migration
  def up
    change_column :venues, :lat, :decimal, :precision => 15, :scale => 10
    change_column :venues, :lng, :decimal, :precision => 15, :scale => 10
  end
end
