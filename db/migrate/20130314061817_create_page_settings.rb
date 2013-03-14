class CreatePageSettings < ActiveRecord::Migration
  def change
    create_table :page_settings do |t|
      t.integer :user_id
      t.string :page_name
      t.string :page_id
      t.text :page_token, limit: nil
      t.string :category
      t.text :perms, limit: nil
      t.timestamps
    end
  end
end
