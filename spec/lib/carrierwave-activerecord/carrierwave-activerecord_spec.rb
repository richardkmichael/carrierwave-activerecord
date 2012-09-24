require 'spec_helper'

describe 'carrierwave-activerecord' do
  describe 'configuration defaults' do
    it 'sets /files as default downloader path prefix' do
      CarrierWave::Uploader::Base.downloader_path_prefix.should eq('/files')
    end
  end

  describe 'configuration options' do
    before :each do
      CarrierWave::Uploader::Base.reset_config
    end

    it 'adds a downloader path prefix' do
      expect { CarrierWave::Uploader::Base.configure {|config| config.downloader_path_prefix = '/images' } }.to_not raise_error
    end
  end

  describe 'cofiguration reset' do
    it 'sets the downloader path prefix to /files' do
      CarrierWave::Uploader::Base.configure {|config| config.downloader_path_prefix = '/images' }
      CarrierWave::Uploader::Base.reset_config

      CarrierWave::Uploader::Base.downloader_path_prefix.should eq('/files')
    end
  end
end
