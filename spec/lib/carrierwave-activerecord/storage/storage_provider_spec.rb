# TODO: Re-factor with implicit subject and review expectations.
# TODO: Deal with @file_properties ivar.

require 'spec_helper'

module CarrierWave 
  module Storage
    module ActiveRecord 

      describe StorageProvider do

        let(:uploader)   { CarrierWave::Uploader::Base.new }
        let(:storage)    { StorageProvider.new(uploader) }
        let(:file)       { mock 'File to store.', @file_properties }
        let(:identifier) { 'identifier' }

        before :each do
          @file_properties = { filename:          'sample.png',
                               original_filename: 'o_sample.png',
                               content_type:      'image/png',
                               extension:         'png',
                               size:              123,
                               read:              1337,
                               data:              1337 }
        end

        describe '#store!(file)' do

          it 'calls File.create!(file, uploader.filename)' do
            File.should_receive(:create!).with(file, uploader.filename)
            storage.store!(file)
          end

          it 'returns a CarrierWave::Storage::ActiveRecord::File' do
            storage.store!(file).should be_instance_of File
          end

          it 'fetches the filename from the uploader' do
            uploader.should_receive(:filename).with(no_args)
            storage.store!(file)
          end
        end

        describe '#retrieve!(identifier)' do

          it 'calls File.fetch!(identifier)' do
            File.should_receive(:fetch!).with(identifier)
            storage.retrieve!(identifier)
          end

          it 'returns a CarrierWave::ActiveRecord::FileProxy' do
            storage.retrieve!(identifier).should be_kind_of File
          end
        end

      end # describe StorageProvider do

    end
  end
end
