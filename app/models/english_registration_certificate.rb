class EnglishRegistrationCertificate < ActiveRecord::Base

  belongs_to :document, dependent: :destroy

end
