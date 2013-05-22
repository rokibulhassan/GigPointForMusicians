class AddSelectedGroupIdToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :selected_group_id, :string
  end
end
