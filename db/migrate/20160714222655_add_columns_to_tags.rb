class AddColumnsToTags < ActiveRecord::Migration
  def change
    add_column :tags, :frequency, :integer, null: false, default: 0
  end
end