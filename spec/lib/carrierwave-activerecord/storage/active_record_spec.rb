require 'spec_helper'
require 'ostruct'

class DummyUploader < CarrierWave::Uploader::Base; end

module CarrierWave 
  module Storage
    module ActiveRecord 
      describe StorageProvider do
        before :each do
          @uploader = DummyUploader.new
          @storage = StorageProvider.new(@uploader)
          @file = double('file')
          @initialization_values = { filename: 'sample.png', original_filename: 'o_sample.png', content_type: 'image/png', size: 123, extension: 'png', data: 1337 }
          @initialization_values.each do |property, value|
            @file.stub(property => value)
          end
          @file.stub(:read => 1337)
        end

        describe '#store!(file)' do
          it 'calls FileProxy.create! with the given file' do
            FileProxy.should_receive(:create!).with(@file)
            @storage.store!(@file)
          end

          it 'returns the file wrapped in an instance of CarrierWave::ActiveRecord::FileProxy' do
            @storage.store!(@file).should be_kind_of FileProxy
          end
        end

        describe '#retrieve!(identifier)' do
          it 'calls FileProxy.fetch!(identifier)' do
            FileProxy.should_receive(:fetch!).with('super_unique_identifier')
            @storage.retrieve!('super_unique_identifier')
          end

          it 'returns an intance of CarrierWave::ActiveRecord::FileProxy' do
            @storage.retrieve!('super_unique_identifier').should be_kind_of FileProxy
          end
        end
      end

      describe FileProxy do
        before :each do
          @file = double('file')
          @initialization_values = { filename: 'sample.png', original_filename: 'o_sample.png', content_type: 'image/png', size: 123, extension: 'png', data: 1337 }
          @initialization_values.each do |property, value|
            @file.stub(property => value)
          end
          @file.stub(:read => 1337)
        end

        describe '.create!(file)' do
          before :each do
            @ar_file = double('active record file')
            @ar_file.stub(:save)
          end

          it 'creates a new instance of the class' do
            File.should_receive(:new).and_return(@ar_file)
            FileProxy.create!(@file)
          end

          it 'returns an instance of FileProxy associated with created File' do
            File.stub(:new => @ar_file)

            FileProxy.create!(@file).file.should eq(@ar_file)
          end

          it 'creates a file in the database' do
            expect { FileProxy.create!(@file) }.to change(File, :count).by(1)
          end

          it 'initializes the file instance' do
            proxy = FileProxy.create!(@file)
            
            @initialization_values.each do |property, value|
              proxy.file.send(property).should eq(value)
            end
          end

        end

        describe '.fetch!(identifier)' do
          context 'given the file exists' do
            it 'returns the file wrapped in a CarrierWave::Storage::ActiveRecord::File object'
          end

          context "given the file doesn't exist" do
            it 'returns an blank instance of CarrierWave::Storage::ActiveRecord::File'
          end
        end
      end

      describe File do

      end
    end
  end # Storage
end # CarrierWave
