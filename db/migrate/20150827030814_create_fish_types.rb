class CreateFishTypes < ActiveRecord::Migration
  def change
    create_table :fish_types do |t|
      t.string :name
      t.integer :point_value

      t.timestamps null: false
    end
  end
end
