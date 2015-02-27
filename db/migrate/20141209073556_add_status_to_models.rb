class AddStatusToModels < ActiveRecord::Migration
  def change
    add_column :settings, :status, :string
    add_column :clocks, :status, :string
  end
end
