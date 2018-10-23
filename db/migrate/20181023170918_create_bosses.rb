class CreateBosses < ActiveRecord::Migration[5.2]
  def change
    create_table :bosses do |t|
      t.string :name
      t.string :description
      t.integer :health
      t.boolean :active

      t.timestamps
    end
  end
end
