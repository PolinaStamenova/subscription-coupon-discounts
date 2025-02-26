# frozen_string_literal: true

RSpec.configure do |config|
  config.use_transactional_fixtures = false # Required for multi-threaded tests

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
