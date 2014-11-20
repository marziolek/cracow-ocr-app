class AddFieldsToEnglishRegistrationCertificate < ActiveRecord::Migration
  def change
    add_column :english_registration_certificates, :registrationNumber, :string
    add_column :english_registration_certificates, :circle, :string
    add_column :english_registration_certificates, :registeredKeeper, :string
    add_column :english_registration_certificates, :referenceNumber, :string
    add_column :english_registration_certificates, :previousRegisteredKeeper, :string
    add_column :english_registration_certificates, :dateOfPurchase, :string
    add_column :english_registration_certificates, :numberOfPreviousOwners, :string
    add_column :english_registration_certificates, :specialNotes, :string
  end
end
