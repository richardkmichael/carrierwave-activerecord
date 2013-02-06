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


  # Tests refute move_to_cache() to be confident about which message should [not] be received.
  context 'with the filesystem cache disabled' do
    it 'should not cache the file' do
      non_caching_uploader.move_to_cache.should be_false
      CarrierWave::SanitizedFile.any_instance.should_not_receive :copy_to
      non_caching_uploader.store! file
    end
  end

  context 'with the filesystem cache enabled' do
    it 'should cache the file' do
      caching_uploader.move_to_cache.should be_false
      CarrierWave::SanitizedFile.any_instance.should_receive :copy_to
      caching_uploader.store! file
    end
  end

end
