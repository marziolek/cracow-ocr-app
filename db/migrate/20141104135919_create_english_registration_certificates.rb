class CreateEnglishRegistrationCertificates < ActiveRecord::Migration
  def change
    create_table :english_registration_certificates do |t|
      t.string :number
      t.belongs_to :document

      t.timestamps
    end
  end
end
