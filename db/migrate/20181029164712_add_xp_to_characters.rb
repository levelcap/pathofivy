class AddXpToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :xp, :bigint, :default => 0
  end
end
