class AddFactionToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :faction, :string
  end
end
