class CreateClocks < ActiveRecord::Migration
  def change
    create_table :clocks do |t|
      t.date :date
      t.time :time
      t.string :user
      t.string :ip
      t.string :action
      t.text :message

      t.timestamps
    end
  end
end
