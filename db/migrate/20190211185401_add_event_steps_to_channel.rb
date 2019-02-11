class AddEventStepsToChannel < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :current_stage_index, :integer, :default => 0
    add_column :channels, :current_step_index, :integer, :default => 0
  end
end
