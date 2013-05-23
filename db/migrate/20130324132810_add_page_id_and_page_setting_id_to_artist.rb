class AddPageIdAndPageSettingIdToArtist < ActiveRecord::Migration
  def change
    add_column :profiles, :page_id, :integer
  end
end
