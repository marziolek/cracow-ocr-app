class EnglishRegistrationCertificate < ActiveRecord::Base

  belongs_to :document, dependent: :destroy

  validates :document, presence: true

end
