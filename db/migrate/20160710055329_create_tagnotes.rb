class CreateTagnotes < ActiveRecord::Migration
  def change
    create_table :tagnotes do |t|
      t.integer :question_id, null: false
      t.integer :tag_id, null: false

      t.timestamps null: false
    end
    add_index :tagnotes, :question_id
    add_index :tagnotes, :tag_id
    add_index :tagnotes, [:question_id, :tag_id], unique: true
  end
end
