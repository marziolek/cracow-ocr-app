class Document < ActiveRecord::Base

  has_one :english_registration_certificate

  mount_uploader :image, ImageUploader

  validates :language, presence: true, inclusion: { in: %w(english)}
  validates :doc_type, presence: true, inclusion: { in: %w(registration_certificate)}
  validates :image, presence: true

end
