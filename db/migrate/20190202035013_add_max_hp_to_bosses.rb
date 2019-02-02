class AddMaxHpToBosses < ActiveRecord::Migration[5.2]
  def change
    add_column :bosses, :maxhealth, :integer
  end
end
