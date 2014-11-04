class Home < ActiveRecord::Base

  mount_uploader :image, ImageUploader

end
