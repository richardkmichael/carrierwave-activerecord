require 'spec_helper'

module CarrierWave 
  module Storage
    module ActiveRecord 
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

          it 'creates a new instance of the File class' do
            File.should_receive(:new).and_return(@ar_file)
            FileProxy.create!(@file,"/uploads/sample.png")
          end

          it 'returns an instance of FileProxy associated with created File' do
            File.stub(:new => @ar_file)

            FileProxy.create!(@file,"/uploads/sample.png").file.should eq(@ar_file)
          end

          it 'creates a file record in the database' do
            expect { FileProxy.create!(@file,"/uploads/sample.png") }.to change(File, :count).by(1)
          end

          it 'initializes the file instance' do
            proxy = FileProxy.create!(@file,"/uploads/sample.png")
            
            @initialization_values.each do |property, value|
              proxy.file.send(property).should eq(value)
            end
          end

          it 'sets the storage path on the file' do
            file = FileProxy.create!(@file, "/uploads/sample.png").file

            file.storage_path.should eq("/uploads/sample.png")
          end
        end

        describe '.fetch!(identifier)' do
          context 'given the file exists' do
            before :each do
              @file_record = File.create!(@initialization_values.merge({:storage_path => "/uploads/sample.png"}))
            end

            it 'returns the file wrapped in a CarrierWave::Storage::ActiveRecord::FileProxy object' do
              FileProxy.fetch!("/uploads/sample.png").should be_instance_of ::CarrierWave::Storage::ActiveRecord::FileProxy
            end

            it 'sets the proxy file property to the file record object' do
              FileProxy.fetch!("/uploads/sample.png").file.should eq(@file_record)
            end
          end

          context "given the file doesn't exist" do
            it 'returns an blank instance of CarrierWave::Storage::ActiveRecord::FileProxy' do
              FileProxy.fetch!("/uploads/sample.png").should be_instance_of ::CarrierWave::Storage::ActiveRecord::FileProxy
            end
          end
        end
      end
    end
  end # Storage
end # CarrierWave
