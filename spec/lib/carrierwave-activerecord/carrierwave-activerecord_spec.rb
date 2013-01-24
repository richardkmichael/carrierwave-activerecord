require 'spec_helper'

describe 'carrierwave-activerecord' do

  let(:uploader) { CarrierWave::Uploader::Base }

  let(:set_alternate_download_url_prefix) do
    CarrierWave::Uploader::Base.configure do |config|
      config.downloader_path_prefix = '/images'
    end
  end

  describe 'configuration defaults' do
    it 'sets /files as default downloader path prefix' do
      uploader.downloader_path_prefix.should eq('/files')
    end
  end

  describe 'configuration options' do
    before :each do
      uploader.reset_config
    end

    it 'adds a downloader path prefix' do
      expect { set_alternate_download_url_prefix }.to_not raise_error
    end
  end

  describe 'configuration reset' do
    it 'sets the downloader path prefix to /files' do
      set_alternate_download_url_prefix

      uploader.reset_config
      uploader.downloader_path_prefix.should eq('/files')
    end
  end
end
