class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.integer :user_id
      t.string :user_name
      t.string :description
      t.string :type
      t.timestamps
    end
  end
end
