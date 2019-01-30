class AddLevelToBosses < ActiveRecord::Migration[5.2]
  def change
    add_column :bosses, :level, :integer
  end
end
