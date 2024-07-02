class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.integer :number, null: false
      t.integer :msgs_count
      t.references :application, null: false, foreign_key: true

      t.timestamps
    end
    add_index :chats, [:application_id, :number], unique: true
    change_column :chats, :msgs_count, :integer, default: 0
  end
end
