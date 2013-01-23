require 'spec_helper'

module CarrierWave 
  module Storage
    module ActiveRecord 

      describe FileProxy do

        let(:file_record) do
          storage_path = { storage_path: '/uploads/sample.png' }
          File.create!(@initialization_values.merge(storage_path))
        end

        before :each do
          File.delete_all
          @file = double('file')

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

        describe '#create!(file)' do

          before :each do
            @ar_file = double('active record file')
            @ar_file.stub(:save)
            @identifier = '/uploads/sample.png'
          end

          it 'creates a new instance of the File class' do
            File.should_receive(:new).and_return(@ar_file)
            FileProxy.create!(@file, @identifier)
          end

          it 'returns an instance of FileProxy associated with created File' do
            File.stub(:new => @ar_file)
            FileProxy.create!(@file, @identifier).file.should eq(@ar_file)
          end

          it 'creates a file record in the database' do
            expect { FileProxy.create!(@file, @identifier) }.to change(File, :count).by(1)
          end

          it 'initializes the file instance' do
            created_file = FileProxy.create!(@file, @identifier)
            
            @initialization_values.each do |property, value|
              created_file.file.send(property).should eq(value)
            end
          end

          it 'sets the storage path on the file' do
            created_file = FileProxy.create!(@file, @identifier).file

            created_file.storage_path.should eq(@identifier)
          end
        end

        describe '#fetch!(identifier)' do

          context 'given the file exists' do

            before :each do
              file_record # ensure its present
              @identifier = '/uploads/sample.png'
            end

            it 'returns an instance of CarrierWave::Storage::ActiveRecord::FileProxy' do
              klass = ::CarrierWave::Storage::ActiveRecord::FileProxy
              FileProxy.fetch!(@identifier).should be_instance_of(klass)
            end

            it 'sets the proxy file property to the file record object' do
              FileProxy.fetch!(@identifier).file.should eq(file_record)
            end
          end

          context 'given the file does not exist' do
            it 'returns a blank instance of CarrierWave::Storage::ActiveRecord::FileProxy' do

              klass = ::CarrierWave::Storage::ActiveRecord::FileProxy
              retrieved_file = FileProxy.fetch!(@identifier)
              retrieved_file.should be_instance_of klass
            end
          end
        end

        describe '#url' do

          before :each do
            file_record # ensure its present
            @identifier = '/uploads/sample.png'
          end

          context 'given the file exists' do

            let(:file_proxy) { FileProxy.fetch!('/uploads/sample.png') }

            it 'returns Uploader.downloader_path_prefix + file.storage_path' do
              file_record #ensure its present
              file_proxy.url.should eq("/files" + @identifier)
            end
          end

          context 'given the file proxy is blank' do

            let(:file_proxy) { FileProxy.fetch!('non-existent-identifier') }
            it 'returns nil' do
              file_proxy.url.should be_nil
            end
          end
        end

#       describe '#blank?' do
#         it 'must be tested'
#       end

        describe '#delete' do

          context 'given the proxy is associated with a file' do

            before :each do
              file_record # ensure it's present
              @identifier = '/uploads/sample.png'

              @proxy = FileProxy.fetch!(@identifier)
            end

            it 'deletes the record' do
              expect { @proxy.delete }.to change( File, :count).by(-1)
            end

            it 'returns true' do
              @proxy.delete.should be_true
            end

          end

          context "given the proxy isn't associated with a file" do
            it 'does nothing' do
              proxy = FileProxy.fetch!('non-existing-identifier')
              proxy.delete.should be_false
            end
          end
        end
      end

    end # ActiveRecord
  end # Storage
end # CarrierWave
