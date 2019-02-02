class AddTrophiesToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :trophies, :integer
  end
end
