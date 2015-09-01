class CreateCatches < ActiveRecord::Migration
  def change
    create_table :catches do |t|
      t.integer :fish_type_id
      t.integer :user_id
      t.float :lat
      t.float :lon
      t.datetime :date
      t.boolean :kept

      t.timestamps null: false
    end
  end
end
