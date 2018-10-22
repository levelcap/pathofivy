class CreateCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :build
      t.integer :level
      t.text :description

      t.timestamps
    end
  end
end
