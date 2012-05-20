class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :nick
      t.string :logo
      t.string :name
      t.string :popular_name
      t.string :acronym
      t.string :slug

      t.timestamps
    end
  end
end
