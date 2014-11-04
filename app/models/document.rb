class Document < ActiveRecord::Base

  has_one :english_registration_certificate

  mount_uploader :image, ImageUploader

end
