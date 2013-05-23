class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :page_id
      t.string :selected
      t.text :token
      t.string :user_id
      t.string :category
      t.text :perms

      t.timestamps
    end
  end
end
