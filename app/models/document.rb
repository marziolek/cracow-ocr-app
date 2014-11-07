class Document < ActiveRecord::Base

  has_one :english_registration_certificate
  has_many :document_images

  validates :language, presence: true, inclusion: { in: %w(English)}
  validates :doc_type, presence: true, inclusion: { in: %w(registration_certificate)}

end
