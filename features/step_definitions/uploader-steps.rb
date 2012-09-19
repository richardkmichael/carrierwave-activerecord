Given /^an uploader class that uses the 'active_record' storage$/ do
  @uploader_class = Class.new(CarrierWave::Uploader::Base)
  @uploader_class.class_eval do
    storage :active_record
  end
end
