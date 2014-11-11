class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :language
      t.string :doc_type
      t.string :image_path
      t.text :translation

      t.timestamps
    end
  end
end
