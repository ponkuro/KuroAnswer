class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.boolean :writable, null: false, default: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
