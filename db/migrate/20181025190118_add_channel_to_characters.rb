class AddChannelToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :channel, :string, :default => 'ivyteapot'
    add_column :bosses, :channel, :string, :default => 'ivyteapot'
  end
end
