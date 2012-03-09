class CreateStadiuns < ActiveRecord::Migration
  def change
    create_table :stadiuns do |t|
      t.integer :max_capaticy
      t.string :inauguration
      t.string :location
      t.string :name
      t.string :popular_name

      t.timestamps
    end
  end
end
