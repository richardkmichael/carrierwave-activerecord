Given /^an uploader class that uses the 'active_record' storage$/ do
  @uploader_class = Class.new(CarrierWave::Uploader::Base)
  @uploader_class.class_eval do
    storage :active_record
  end
end

Given /^an instance of that class$/ do
  @uploader = @uploader_class.new
end

def ensure_dummy_file_present file_path
  f = File.open(file_path,"w")
  f.write(<<FILE)
Some example content written into a test file.
And another line.
FILE
  f.close
end

When /^I store the file 'fixtures\/(\w+\.\w+)'$/ do |filename|
  file_path = "features/fixtures/#{filename}"
  ensure_dummy_file_present file_path
  f = File.open(file_path,'r')
  @uploader.store!(f)
end

Then /^there should be one file in the database named '(\w+\.\w+)'$/ do |filename|
  CarrierWave::Storage::ActiveRecord::File.find_by_filename(filename).should_not be_nil
end

Then /^that file should be identical to the file at 'fixtures\/(\w+\.\w+)'$/ do |filename|
  file = CarrierWave::Storage::ActiveRecord::File.find_by_filename(filename)
  file_path = "features/fixtures/#{filename}"
  ensure_dummy_file_present file_path
  file.data.should == File.open(file_path, "r") { |f| f.read }
end
