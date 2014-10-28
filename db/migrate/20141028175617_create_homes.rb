class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.string :language
      t.string :document_type
      t.string :image

      t.timestamps
    end
  end
end
