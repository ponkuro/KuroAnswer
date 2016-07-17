class CreatePvcounts < ActiveRecord::Migration
  def change
    create_table :pvcounts do |t|
      t.references :question, index: true, foreign_key: true
      t.integer :timescope, null: false
      t.integer :pv, null: false, default: 0
      t.integer :pv_24hr, null: false, default: 0
      t.integer :pv_prev23, null: false, default: 0

      t.timestamps null: false
    end
    add_index :pvcounts, [:question_id, :timescope], unique: true
  end
end