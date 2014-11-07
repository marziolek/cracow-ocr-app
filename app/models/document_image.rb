class DocumentImage < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :document, dependent: :destroy
end
