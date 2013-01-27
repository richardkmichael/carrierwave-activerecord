# TODO: Re-factor to use implicit subject and review expectations.
#
# TODO: We use mocks with .and_call_original because the methods being
# tested must execute the rest of the method to decorate the returned
# File.  Alternately, we could use .and_return(@active_record_file_mock)
# to inject the correct type of file [build it from a Factory, because
# otherwise, the mocked file and the real File will eventually be out of
# sync.
#
# TODO: Remove deep "implementation" testing, e.g. "calls #create!".
#
# TODO: Instead of specing the return behavior of "store!" *and*
# "retrieve!", should we spec the return behaviour of only "retrieve!"
# and then specifiy that "store!" and "retrieve!" should return the same
# thing?


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
        let(:file_properties) { { filename:          'sample.png',
                                  original_filename: 'o_sample.png',
                                  content_type:      'image/png',
                                  extension:         'png',
                                  size:              123,
                                  read:              1337,
                                  data:              1337 } }

        let(:mock_rails_url_helpers) do
          article = mock 'Article 1'
          article.stub_chain('class.to_s') { 'Article' } # Avoid dynamic creation of a named class.

          url_helpers = mock 'Rails URL helpers module'
          url_helpers.should_receive(:article_path).with(article).and_return('/articles/1')

          stub_const('Rails', 'Rails')
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

          context 'with ::Rails' do
            it 'sets the URL property on the returned file' do
              mock_rails_url_helpers
              storage.store!(file).url.should eq rails_url
            end
          end

          context 'without ::Rails' do
            it 'sets the file URL to a helpful message' do
              storage.store!(file).url.should eq storage_provider_url
            end
          end

          context 'with a default_url defined in the uploader' do
            it 'sets the file URL to the default url' do
              add_default_url_to_uploader
              storage.store!(file).url.should eq uploader_default_url
            end
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

          context 'with ::Rails' do
            it 'sets the URL property on the returned file' do
              mock_rails_url_helpers
              storage.retrieve!(identifier).url.should eq rails_url
            end
          end

          context 'without ::Rails' do
            it 'sets the file URL to a helpful message' do
              storage.retrieve!(identifier).url.should eq storage_provider_url
            end
          end

          context 'with a default_url defined in the uploader' do
            it 'sets the file URL to the default url' do
              add_default_url_to_uploader
              storage.store!(file).url.should eq uploader_default_url
            end
          end
        end

      end # describe StorageProvider do

    end
  end
end
