class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.time :complete_time

      t.timestamps
    end
  end
end
