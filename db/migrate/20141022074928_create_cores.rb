class CreateCores < ActiveRecord::Migration
  def change
    create_table :cores do |t|

      t.timestamps
    end
  end
end
