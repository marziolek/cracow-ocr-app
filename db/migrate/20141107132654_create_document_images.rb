class CreateDocumentImages < ActiveRecord::Migration
  def change
    create_table :document_images do |t|
      t.belongs_to :document
      t.string :image

      t.timestamps
    end
  end
end
