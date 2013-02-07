require 'spec_helper'

module CarrierWave 
  module Storage
    module ActiveRecord

      describe StorageProvider do

        # Configure the uploader with our storage provider so methods
        # proxy to us; else, they proxy to the default storage provider.
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
        let(:file_properties) { { original_filename: 'o_sample.png',
                                  content_type:      'image/png',
                                  size:              123,
                                  data:              1337,
                                  read:              1337 } }

        let(:mock_rails_url_helpers) do
          article = mock 'Article 1'
          article.stub_chain('class.to_s') { 'Article' } # Avoid dynamic creation of a named class.

          url_helpers = mock 'Rails URL helpers module'
          url_helpers.should_receive(:article_path).with(article).and_return('/articles/1')

          stub_const('::Rails', 'Rails')
          Rails.stub_chain('application.routes.url_helpers') { url_helpers }

          uploader.should_receive(:model).and_return(article)
          uploader.should_receive(:mounted_as).and_return(:file)
        end

        let(:rails_url)            { '/articles/1/file' }
        let(:storage_provider_url) { [ uploader.download_path_prefix, identifier].join '/' }

        let(:uploader_default_url) { "/url/to/#{identifier}" }

        def add_default_url_to_uploader
          uploader.class_eval { def default_url ; "/url/to/#{identifier}" ; end }
        end

        describe '#store!(file)' do

          subject { storage.store! file }

          it        { should be_an_instance_of File }
          its(:url) { should eq storage_provider_url }

          it 'should create a File instance' do
            File.should_receive(:create!).with(file, identifier).and_call_original
            storage.store! file
          end

          it 'should ask the uploader for the filename' do
            uploader.should_receive(:filename).with(no_args)
            storage.store!(file)
          end

          context 'with ::Rails' do
            it 'should set the URL property on the returned file' do
              mock_rails_url_helpers
              storage.store!(file).url.should eq rails_url
            end
          end

          context 'with a default_url defined in the uploader' do
            it 'should set the file URL to the default url' do
              add_default_url_to_uploader
              storage.store!(file).url.should eq uploader_default_url
            end
          end

        end

        describe '#retrieve!(identifier)' do

          before(:each) { create_a_file_in_the_database file_properties }

          subject { storage.retrieve! identifier }

          it        { should be_a_kind_of File }
          its(:url) { should eq storage_provider_url }

          it 'should fetch a File instance' do
            File.should_receive(:fetch!).with(identifier).and_call_original
            storage.retrieve!(identifier)
          end

          context 'with ::Rails' do
            it 'should set the URL property on the returned file' do
              mock_rails_url_helpers
              storage.retrieve!(identifier).url.should eq rails_url
            end
          end

          context 'with a default_url defined in the uploader' do
            it 'should set the file URL to the default url' do
              add_default_url_to_uploader
              storage.store!(file).url.should eq uploader_default_url
            end
          end
        end

      end # describe StorageProvider do
    end # ActiveRecord
  end # Storage
end # CarrierWave
