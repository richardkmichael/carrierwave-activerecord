class Avatar < ActiveRecord::Base

  belongs_to :person
  attr_accessible :file
# mount_uploader  :file, AvatarUploader

end
