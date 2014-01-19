class RenameNoteToNotesInTrades < ActiveRecord::Migration
  def up
    rename_column :trades, :note, :notes
  end

  def down
  end
end
