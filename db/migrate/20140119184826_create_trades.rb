class CreateTrades < ActiveRecord::Migration
  def up
    create_table :trades do |t|
      t.string :from
      t.string :to
      t.string :offer
      t.string :note
      t.timestamps
    end
  end

  def down
    drop_table :trades
  end
end
