class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :name
      t.references :user

      t.timestamps
    end
    add_index :rules, :user_id
  end
end
