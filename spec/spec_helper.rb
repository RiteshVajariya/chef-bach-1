require 'simplecov'
require 'rspec/matchers'

formatters = [ SimpleCov::Formatter::HTMLFormatter ]

begin
  require 'simplecov-json'
  formatters.push(SimpleCov::Formatter::JSONFormatter)
rescue LoadError
end

begin
  require 'simplecov-rcov'
  formatters.push(SimpleCov::Formatter::RcovFormatter)
rescue LoadError
end

SimpleCov.formatters = formatters
SimpleCov.start

# Require all our libraries
# XXX Dir["#{__dir__}/../bin/*.rb"].each do |f|
# XXX   begin
# XXX     require File.expand_path(f)
# XXX   rescue NameError => ex
# XXX     STDERR.write("Failed to load: #{ex}")
# XXX   end
# XXX end

RSpec.configure do |config|
  config.color = true
  config.alias_example_group_to :describe_recipe, type: :recipe

  Kernel.srand config.seed
  config.order = :random

  # run as though rspec --format documentation when passing a single spec file
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end

at_exit { ChefSpec::Coverage.report! }
