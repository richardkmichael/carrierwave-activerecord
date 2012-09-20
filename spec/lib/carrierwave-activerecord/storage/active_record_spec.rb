require 'spec_helper'

describe CarrierWave::Storage::ActiveRecord do
  describe '#store!(file)' do
    it 'creates an instance of CarrierWave::Storage::ActiveRecord::File'
    it 'returns the file object'
  end

  describe '#retrieve!(identifier)' do
    context 'given the file exists' do
      it 'returns the file wrapped in a CarrierWave::Storage::ActiveRecord::File object'
    end

    context "given the file doesn't exist" do
      it 'returns an blank instance of CarrierWave::Storage::ActiveRecord::File'
    end
  end
end
