require 'spec_helper'

describe 'carrierwave-activerecord' do

  let(:uploader_class) { CarrierWave::Uploader::Base }

# let(:active_record_file_class) { CarrierWave::Storage::ActiveRecord::ActiveRecordFile }

  let(:set_alternate_download_url_prefix) do
    uploader_class.configure do |config|
      config.download_path_prefix = '/images'
    end
  end

  let(:set_custom_table_name) do
    uploader_class.configure do |config|
      config.active_record_tablename = 'custom_table_name'
    end
  end

  describe 'configuration defaults' do
    it 'sets "/files" as default download path prefix' do
      uploader_class.download_path_prefix.should eq '/files'
    end

    it 'sets "carrier_wave_files" as default ActiveRecord table' do
      uploader_class.active_record_tablename.should eq 'carrier_wave_files'
    end
  end

  describe 'setting configuration options' do
    before :each do
      uploader_class.reset_config
    end

    it 'can set a download path prefix' do
      expect { set_alternate_download_url_prefix }.to_not raise_error
      uploader_class.download_path_prefix.should eq '/images'
    end

    it 'can set a custom table name' do
      expect { set_custom_table_name }.to_not raise_error
      uploader_class.active_record_tablename.should eq 'custom_table_name'
    end
  end

  describe 'configuration reset' do
    it 'sets the download path prefix to "/files"' do
      set_alternate_download_url_prefix

      uploader_class.reset_config
      uploader_class.download_path_prefix.should eq '/files'
    end
  end

end
