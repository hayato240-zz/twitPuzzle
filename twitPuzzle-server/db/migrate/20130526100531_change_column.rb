class ChangeColumn < ActiveRecord::Migration
  def change
      change_column :rankings, :complete_time, :float
  end
end
