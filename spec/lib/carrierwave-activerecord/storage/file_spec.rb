# TODO: Re-factor with implicit subject and review expectations.

# TODO: Write create specs to cover the case when a same-named file already
#       exists; e.g. push into the two contexts.

# TODO: Set to a SHA1; it will matter once validations are on
#       the ARFile and constraints are in the database.

# TODO: In the description of an "it ... do", we can't use a let.  In
#       the block of an "it ... do", we can't use an instance variable.
#       This makes it hard to DRY out the spec: @provider_file_class.

# TODO: Should we return anything for CW::B::Proxy#path() and
#       CW::SanitizedFile#rewind() ?

# TODO: Test content_type= when a file was not found in the database?

require 'spec_helper'

module CarrierWave 
  module Storage
    module ActiveRecord 

      describe File do

        it { should respond_to(:url) }                                # Uploader::Base::Url
        it { should respond_to(:blank?, :identifier, :read, :size) }  # Uploader::Base::Proxy
        it { should respond_to(:content_type, :content_type=) }       # Uploader::Base::MimeTypes
        it { should respond_to(:destroy!) }                           # Uploader::Base::RMagick
        it { should respond_to(:original_filename, :size) }           # CarrierWave::SanitizedFile

        let(:provider_file_class) { ::CarrierWave::Storage::ActiveRecord::File }

        let(:identifier) { '/uploads/sample.png' }

        let(:file_properties) { { original_filename: 'o_sample.png',
                                  content_type:      'image/png',
                                  size:              123,
                                  data:              'File content.',
                                  read:              'File content.' } }

        before :each do
          CarrierWave::Storage::ActiveRecord::File.delete_all
        end

        describe '#create! file' do

          let(:active_record_file) { mock 'ActiveRecordFile stored.', file_properties.merge(save: nil) }
          let(:file_to_store)      { mock 'File to store.',           file_properties.merge(save: nil) }

          it 'returns a File instance' do
            ActiveRecordFile.should_receive(:new).and_return(active_record_file)
            stored_file = File.create!(file_to_store, identifier)
            stored_file.should be_instance_of File
          end

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

            file_properties.each do |property, value|
              stored_file.file.send(property).should eq value
            end
          end

          it 'sets the identifier on the file' do
            stored_file = File.create!(file_to_store, identifier).file
            stored_file.identifier.should eq identifier
          end
        end


        context 'given the file exists in the database' do

          let(:retrieved_file) { File.fetch! identifier }

          before :each do
            @stored_file = create_a_file_in_the_database file_properties
            ActiveRecordFile.count.should eq(1)
          end

          describe '#fetch!(identifier)' do
            it 'returns a CarrierWave::Storage::ActiveRecord::File' do
              retrieved_file.should be_instance_of provider_file_class
            end

            it 'sets the file property to the file from the database' do
              retrieved_file.file.should eq @stored_file
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

          describe '#blank?' do
            it 'returns false' do
              retrieved_file.blank?.should be_false
            end
          end

          describe '#read' do
            it 'returns the file contant' do
              retrieved_file.read.should eq 'File content.'
            end
          end

          describe '#size' do
            it 'returns 123' do
              # TODO: Should we be computing the size, instead of storing the attribute?
              retrieved_file.size.should eq 123
            end
          end

          describe '#identifier' do
            it 'returns the identifier' do
              retrieved_file.identifier.should eq identifier
            end
          end

          describe '#original_filename' do
            it 'returns the original filename' do
              retrieved_file.original_filename.should eq 'o_sample.png'
            end
          end

          describe '#content_type' do
            it 'returns the content type' do
              retrieved_file.content_type.should eq 'image/png'
            end
          end

          describe '#content_type=' do
            it 'sets the content type' do
              retrieved_file.content_type = 'text/plain'
              retrieved_file.content_type.should eq 'text/plain'
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

          describe '#blank?' do
            it 'returns true' do
              retrieved_file.blank?.should be_true
            end
          end

          describe '#read' do
            it 'returns nil' do
              retrieved_file.read.should be_nil
            end
          end

          describe '#size' do
            it 'returns nil' do
              retrieved_file.size.should be_nil
            end
          end

          describe '#identifier' do
            it 'returns nil' do
              retrieved_file.identifier.should be_nil
            end
          end

          describe '#original_filename' do
            it 'returns nil' do
              retrieved_file.original_filename.should be_nil
            end
          end

          describe '#content_type' do
            it 'returns nil' do
              retrieved_file.content_type.should be_nil
            end
          end
        end

      end # describe File do

    end # ActiveRecord
  end # Storage
end # CarrierWave
