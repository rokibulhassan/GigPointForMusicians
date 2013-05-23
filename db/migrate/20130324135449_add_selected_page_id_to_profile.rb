class AddSelectedPageIdToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :selected_page_id, :string
  end
end
