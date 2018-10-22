class AddLastQuestDateToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :last_quest_date, :datetime
  end
end
