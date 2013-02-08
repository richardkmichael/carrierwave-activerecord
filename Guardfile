guard 'rspec', cli: '--color' do
  watch(%r{^spec/.+_spec\.rb$})

  watch('spec/spec_helper.rb') { 'spec' }

  watch(%r{^lib/(.+)\.rb$}) do |m|
    "spec/lib/#{m[1]}_spec.rb"
  end
end

