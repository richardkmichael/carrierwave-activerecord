require 'spec_helper'

# FIXME: This spec can't go in CW::Uploader, describe Base; because then the instance creation
#        doesn't work: uninitialized constant.
describe 'Uploader' do

  # TODO: This is the subject, but with configuration: investigate "it" configuration in rspec.
  # FIXME: It should be using active_record storage all the time.
  let(:caching_uploader) do
    Class.new(CarrierWave::Uploader::Base) do
      configure do |config|
        storage_provider_class = 'CarrierWave::Storage::ActiveRecord::StorageProvider'
        config.storage_engines[:active_record] = storage_provider_class
      end

      storage :active_record
    end.new
  end

  let(:non_caching_uploader) do
    Class.new(CarrierWave::Uploader::Base) do
      configure do |config|
        storage_provider_class = 'CarrierWave::Storage::ActiveRecord::StorageProvider'
        config.storage_engines[:active_record] = storage_provider_class
        config.use_filesystem_cache = false
      end

      storage :active_record
    end.new
  end

  let(:file)            { mock 'File to store.', file_properties }
  let(:file_properties) { { original_filename: 'o_sample.png',
                            content_type:      'image/png',
                            size:              123,
                            data:              1337,
                            read:              1337 } }

  context 'with the filesystem cache disabled' do

    it 'should not cache the file' do

      # No file should be written, or moved or copied.
      ::FileUtils.should_not_receive :mv
      ::FileUtils.should_not_receive :cp
      File.any_instance.should_not_receive :write

      non_caching_uploader.store! file
    end
  end

  context 'with the filesystem cache enabled' do
    it 'should cache the file' do

      # If the file exists, it will be moved or copied; otherwise, a new file written.
      ::FileUtils.should_receive :mv ||
      ::FileUtils.should_receive :cp ||
      File.any_instance.should_receive :write

      caching_uploader.store! file
    end
  end

end
