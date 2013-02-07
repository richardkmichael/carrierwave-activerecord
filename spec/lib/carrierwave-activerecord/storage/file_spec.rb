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
        let(:identifier)          { '/uploads/sample.png' }
        let(:active_record_file)  { mock 'ActiveRecordFile stored.', file_properties.merge(save: nil) }
        let(:file_to_store)       { mock 'File to store.',           file_properties.merge(save: nil) }
        let(:file_properties)     { { original_filename: 'o_sample.png',
                                      content_type:      'image/png',
                                      size:              123,
                                      data:              'File content.',
                                      read:              'File content.' } }

        before(:each) { CarrierWave::Storage::ActiveRecord::File.delete_all }

        describe '#create!(file)' do

          # TODO: This tests ActiveRecordFile; we shouldn't do that here.
          it 'should create an ActiveRecordFile instance' do
            ActiveRecordFile.should_receive(:new).and_return(active_record_file)
            File.create!(file_to_store, identifier)
          end

          it 'should return a File instance' do
            ActiveRecordFile.should_receive(:new).and_return(active_record_file)
            stored_file = File.create!(file_to_store, identifier)
            stored_file.should be_instance_of File
          end

          it 'should return a File instance with an associated ActiveRecordFile instance' do
            ActiveRecordFile.stub(new: active_record_file)
            stored_file = File.create!(file_to_store, identifier)
            stored_file.file.should eq active_record_file
          end

          it 'should create a record in the database' do
            expect { File.create!(file_to_store, identifier) }.to change(ActiveRecordFile, :count).by(1)
          end

          # TODO: This tests ActiveRecordFile; we shouldn't do that here.
          it 'should initialize the file instance' do
            stored_file = File.create!(file_to_store, identifier)

            file_properties.each do |property, value|
              stored_file.file.send(property).should eq value
            end
          end

          it 'should set the identifier on the file' do
            stored_file = File.create!(file_to_store, identifier).file
            stored_file.identifier.should eq identifier
          end
        end


        describe '#fetch!(identifier)' do

          subject { File.fetch! identifier }

          context 'given the file exists in the database' do

            before :each do
              @stored_file = create_a_file_in_the_database file_properties
              ActiveRecordFile.count.should eq(1)
            end

            it                      { should     be_instance_of provider_file_class }
            it                      { should_not be_blank }
            its(:read)              { should eq 'File content.' }
            its(:size)              { should eq 123 }
            its(:file)              { should eq @stored_file }
            its(:identifier)        { should eq identifier }
            its(:content_type)      { should eq 'image/png' }
            its(:original_filename) { should eq 'o_sample.png' }
            its(:delete)            { should be_true }

            # TODO: How to refactor expect{} and assignment spec to use
            #       an implicit subject?
            let(:retrieved_file) { File.fetch! identifier }

            it 'deletes the record' do
              expect { retrieved_file.delete }.to change( ActiveRecordFile, :count).by(-1)
            end

            it 'sets the content type' do
              retrieved_file.content_type = 'text/plain'
              retrieved_file.content_type.should eq 'text/plain'
            end
          end


          # TODO: Why does this return anything at all, instead of 'nil'?
          context 'given the file does not exist in the database' do

            let(:identifier) { 'non-existent-identifier' }

            it { should be_blank }
            it { should be_instance_of provider_file_class }

            its(:url)               { should be_nil }
            its(:read)              { should be_nil }
            its(:size)              { should be_nil }
            its(:file)              { should be_nil }
            its(:identifier)        { should be_nil }
            its(:content_type)      { should be_nil }
            its(:original_filename) { should be_nil }
            its(:delete)            { should be_false }
          end
        end

      end # describe File do

    end # ActiveRecord
  end # Storage
end # CarrierWave
