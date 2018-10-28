class AddBossDamageToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :boss_damage, :integer, :default => 0
  end
end
