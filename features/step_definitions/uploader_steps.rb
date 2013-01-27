Given(/^an uploader using 'active_record' storage$/) do
  @uploader_class = Class.new(CarrierWave::Uploader::Base)
  @uploader_class.storage = :active_record
  @uploader_class.delete_tmp_file_after_storage = false

  @uploader = @uploader_class.new
end

When(/^I upload the fixture file '(\w+\.\w+)'$/) do |filename|
  @file_path = "fixtures/#{filename}"
  @file = File.open @file_path,'r'

  @uploader.store! @file
  @identifier = @uploader.identifier
end

Then(/^the file should be stored in the database$/) do
  @stored_file = CarrierWave::Storage::ActiveRecord::File.fetch! @identifier
  @stored_file.file.should_not be_nil
end

Then(/^the database file should be identical to the fixture file$/) do
  file = File.open @file_path,'r'
  @stored_file.file.data.should == file.read
end
