class Person < ActiveRecord::Base

  # Single avatar.
  # attr_accessible :avatar, :name
  # mount_uploader :avatar, AvatarUploader

  # Multiple avatars; uploader is mounted in the Avatar class.
  attr_accessible :name, :avatar_attributes
  has_many                      :avatars, :dependent     => :destroy
  accepts_nested_attributes_for :avatars, :allow_destroy => true

end
