require 'spec_helper'

module CarrierWave 
  module Storage
    module ActiveRecord 

      describe StorageProvider do

        class DummyUploader < CarrierWave::Uploader::Base
          def store_path
            '/uploads/bla.txt'
          end
        end

        before :each do
          @uploader = DummyUploader.new
          @storage  = StorageProvider.new(@uploader)
          @file     = double('file')

          @initialization_values = { filename:          'sample.png',
                                     original_filename: 'o_sample.png',
                                     content_type:      'image/png',
                                     extension:         'png',
                                     size:              123,
                                     data:              1337 }

          @initialization_values.each do |property, value|
            @file.stub(property => value)
          end

          @file.stub(:read => 1337)
        end

        describe '#store!(file)' do

          it 'calls FileProxy.create! with the given file and the storage path' do
            FileProxy.should_receive(:create!).with(@file, @uploader.filename)
            @storage.store!(@file)
          end

          it 'returns an instance of CarrierWave::Storage::ActiveRecord::FileProxy' do
            @storage.store!(@file).should be_kind_of FileProxy
          end

          it 'fetches the storage path from the uploader' do
            @uploader.should_receive(:filename).with(no_args)
            @storage.store!(@file)
          end
        end

        describe '#retrieve!(identifier)' do

          it 'calls FileProxy.fetch!(identifier)' do
            FileProxy.should_receive(:fetch!).with('super_unique_identifier')
            @storage.retrieve!('super_unique_identifier')
          end

          it 'returns an instance of CarrierWave::ActiveRecord::FileProxy' do
            @storage.retrieve!('super_unique_identifier').should be_kind_of FileProxy
          end

        end
      end
    end
  end
end
