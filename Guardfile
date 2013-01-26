# guard 'cucumber' do
#   watch(%r{^features/.+\.feature$})

#   watch(%r{^features/support/.+$}) { 'features' }

#   watch(%r{^features/step_definitions/(.+)_steps\.rb$}) do |step_file|
#     Dir[File.join("**/#{step_file[1]}.feature")][0] || 'features'
#   end
# end

guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})

  watch('spec/spec_helper.rb') { 'spec' }

  watch(%r{^lib/(.+)\.rb$}) do |m|
    "spec/lib/#{m[1]}_spec.rb"
  end
end

