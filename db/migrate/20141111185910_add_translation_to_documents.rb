class AddTranslationToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :translation, :string
  end
end
