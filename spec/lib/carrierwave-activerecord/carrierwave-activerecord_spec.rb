require 'spec_helper'

describe 'carrierwave-activerecord' do

  let(:uploader) { CarrierWave::Uploader::Base }

  let(:set_alternate_download_url_prefix) do
    CarrierWave::Uploader::Base.configure do |config|
      config.download_path_prefix = '/images'
    end
  end

  describe 'configuration defaults' do
    it 'sets /files as default download path prefix' do
      uploader.download_path_prefix.should eq '/files'
    end
  end

  describe 'configuration options' do
    before :each do
      uploader.reset_config
    end

    it 'adds a download path prefix' do
      expect { set_alternate_download_url_prefix }.to_not raise_error
      uploader.download_path_prefix.should eq '/images'
    end
  end

  describe 'configuration reset' do
    it 'sets the download path prefix to /files' do
      set_alternate_download_url_prefix

      uploader.reset_config
      uploader.download_path_prefix.should eq '/files'
    end
  end

end
