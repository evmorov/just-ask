require 'rails_helper'
require 'capybara/email/rspec'
require 'capybara-screenshot/rspec'

Sidekiq::Testing.inline!

RSpec.configure do |config|
  Capybara.register_driver :selenium do |app|
    options = Selenium::WebDriver::Chrome::Options.new(
      args: %w[headless disable-gpu window-size=1366,768],
    )
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  Capybara.ignore_hidden_elements = true
  Capybara.register_server :puma do |app, port, host|
    require 'rack/handler/puma'
    Rack::Handler::Puma.run(app, Host: host, Port: port, Threads: '0:4', config_files: ['-'])
  end
  Capybara.server = :puma

  config.include AcceptanceMacros, type: :feature
  config.include WaitForAjax, type: :feature
  config.include MailHelpers, type: :feature
  config.include SphinxHelpers, type: :feature

  config.before do |example|
    if example.metadata[:type] == :feature
      Sidekiq::Testing.inline!
      default_url_options[:host] = 'http://localhost:3000'
      clear_emails
    end
  end

  config.use_transactional_fixtures = false

  config.before(:suite) do
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

OmniAuth.config.test_mode = true
