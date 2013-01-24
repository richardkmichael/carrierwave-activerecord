# TODO: Re-factor with implicit subject and review expectations.
# TODO: Deal with @file_properties ivar.
# TODO: Write create specs to cover the case when a same-named file already
#       exists; e.g. push into the two contexts.

require 'spec_helper'

module CarrierWave 
  module Storage
    module ActiveRecord 

      describe File do

        def create_a_file_in_the_database
          ActiveRecordFile.create! @file_properties.merge!({ storage_path: identifier })
        end

        let(:identifier) { '/uploads/sample.png' }

        # In the description of an "it ... do", we can't use a let.  In the
        # block of an "it ... do", we can't use an instance variable.  This
        # makes it hard to DRY out the spec.
        # @provider_file_class = ::CarrierWave::Storage::ActiveRecord::File
        let(:provider_file_class) { ::CarrierWave::Storage::ActiveRecord::File }

        before :each do
          @file_properties = { filename:          'sample.png',
                               original_filename: 'o_sample.png',
                               content_type:      'image/png',
                               extension:         'png',
                               read:              1337,
                               data:              1337,
                               size:              123 }

          CarrierWave::Storage::ActiveRecord::File.delete_all
        end

        describe '#create!(file)' do
          let(:active_record_file) { mock 'ActiveRecordFile stored.', @file_properties.merge(save: nil) }
          let(:file_to_store)      { mock 'File to store.',           @file_properties.merge(save: nil) }

          it 'creates an ActiveRecordFile instance' do
            ActiveRecordFile.should_receive(:new).and_return(active_record_file)
            File.create!(file_to_store, identifier)
          end

          it 'returns a file with an associated ActiveRecordFile' do
            ActiveRecordFile.stub(new: active_record_file)
            stored_file = File.create!(file_to_store, identifier)
            stored_file.file.should eq(active_record_file)
          end

          it 'creates a file record in the database' do
            expect { File.create!(file_to_store, identifier) }.to change(ActiveRecordFile, :count).by(1)
          end

          it 'initializes the file instance' do
            stored_file = File.create!(file_to_store, identifier)

            @file_properties.each do |property, value|
              stored_file.file.send(property).should eq(value)
            end
          end

          it 'sets the storage path on the file' do
            stored_file = File.create!(file_to_store, identifier).file
            stored_file.storage_path.should eq(identifier)
          end
        end


        context 'given the file exists in the database' do

          let(:retrieved_file) { File.fetch! identifier }

          before :each do
            @stored_file = create_a_file_in_the_database
          end

          describe '#fetch!(identifier)' do
            it 'returns a CarrierWave::Storage::ActiveRecord::File' do
              retrieved_file.should be_instance_of provider_file_class
            end

            it 'sets the file property to the file from the database' do
              retrieved_file.file.should eq(@stored_file)
            end
          end

          describe '#url' do
            it 'returns Uploader.downloader_path_prefix + file.storage_path' do
              retrieved_file.url.should eq('/files' + identifier)
            end
          end

          describe '#delete' do
            it 'deletes the record' do
              expect { retrieved_file.delete }.to change( ActiveRecordFile, :count).by(-1)
            end

            it 'returns true' do
              retrieved_file.delete.should be_true
            end
          end
        end


        context 'given the file does not exist in the database' do

          let(:retrieved_file) { File.fetch! 'non-existent-identifier' }

          describe '#fetch!(identifier)' do
            it 'returns a CarrierWave::Storage::ActiveRecord::File' do
              retrieved_file.should be_instance_of provider_file_class
            end
          end

          describe '#url' do
            it 'returns nil' do
              retrieved_file.url.should be_nil
            end
          end

          describe '#delete' do
            it 'returns false' do
              retrieved_file.delete.should be_false
            end
          end
        end

      end # describe File do

    end # ActiveRecord
  end # Storage
end # CarrierWave
