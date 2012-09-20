Given /^an uploader class that uses the 'active_record' storage$/ do
  @uploader_class = Class.new(CarrierWave::Uploader::Base)
  @uploader_class.class_eval do
    storage :active_record
  end
end

Given /^an instance of that class$/ do
  @uploader = @uploader_class.new
end


When /^I store the file 'fixtures\/(\w+\.\w+)'$/ do |filename|
  f = File.open("features/fixtures/#{filename}",'r')
  @uploader.store!(f)
end
