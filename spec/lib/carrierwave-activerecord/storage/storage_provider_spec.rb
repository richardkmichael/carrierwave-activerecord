# TODO: Re-factor with implicit subject and review expectations.
#
# TODO: Deal with @file_properties ivar.
#
# TODO: We use mocks with .and_call_original because the methods being
# tested must execute the rest of the method to decorate the returned
# File.  Alternately, we could use .and_return(@active_record_file_mock)
# to inject the correct type of file [build it from a Factory, because
# otherwise, the mocked file and the real File will eventually be out of
# sync.

require 'spec_helper'

module CarrierWave 
  module Storage
    module ActiveRecord 

      describe StorageProvider do

        # The uploader must be configured with our storage provider,
        # otherwise, it will not proxy methods to us (they would go to
        # the default storage provider - File).
        let(:uploader) do
          Class.new(CarrierWave::Uploader::Base) do
            configure do |config|
              storage_provider_class = 'CarrierWave::Storage::ActiveRecord::StorageProvider'
              config.storage_engines[:active_record] = storage_provider_class
            end

            storage :active_record
          end.new
        end

        let(:identifier)      { uploader.identifier }
        let(:storage)         { StorageProvider.new uploader }
        let(:file)            { mock 'File to store.', file_properties }
        let(:file_properties) { { filename:          'sample.png',
                                  original_filename: 'o_sample.png',
                                  content_type:      'image/png',
                                  extension:         'png',
                                  size:              123,
                                  read:              1337,
                                  data:              1337 } }


        describe '#store!(file)' do

          it 'calls File.create!(file, uploader.identifier)' do
            File.should_receive(:create!).with(file, uploader.identifier).and_call_original
            storage.store! file
          end

          it 'returns a CarrierWave::Storage::ActiveRecord::File' do
            storage.store!(file).should be_instance_of File
          end

          it 'fetches the filename from the uploader' do
            uploader.should_receive(:filename).with(no_args)
            storage.store!(file)
          end

          it 'sets the URL property on the returned file' do
            storage.store!(file).url.should eq('/files' + identifier)
          end
        end

        describe '#retrieve!(identifier)' do

          before :each do
            create_a_file_in_the_database file_properties
          end

          it 'calls File.fetch!(identifier)' do
            File.should_receive(:fetch!).with(identifier).and_call_original
            storage.retrieve!(identifier)
          end

          it 'returns a CarrierWave::ActiveRecord::File' do
            storage.retrieve!(identifier).should be_kind_of File
          end

          it 'sets the URL property on the returned file' do
            storage.retrieve!(identifier).url.should eq('/files' + identifier)
          end
        end

      end # describe StorageProvider do

    end
  end
end
