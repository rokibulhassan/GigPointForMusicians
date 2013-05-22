class CreateGroup < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :group_id
      t.integer :user_id
      t.timestamps
    end
  end
end
