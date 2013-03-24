class ChangeUserIdTypeToPage < ActiveRecord::Migration
  def up
    remove_column :profiles, :user_id
    add_column :profiles, :user_id, :integer
  end

  def down
  end
end
