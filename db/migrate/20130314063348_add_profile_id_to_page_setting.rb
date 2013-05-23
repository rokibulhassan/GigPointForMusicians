class AddProfileIdToPageSetting < ActiveRecord::Migration
  def change
    add_column :page_settings, :profile_id, :integer
  end
end
