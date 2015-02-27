class ChangeTimeField < ActiveRecord::Migration
  def change
    remove_column :clocks, :time
    add_column :clocks, :time, :datetime
  end
end
