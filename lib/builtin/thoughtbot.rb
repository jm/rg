template(:thoughtbot) do
  gem 'mislav-will_paginate'
  gem 'RedCloth'
  gem 'mocha'
  gem 'thoughtbot-factory_girl'
  gem 'thoughtbot-shoulda'
  gem 'quietbacktrace'
  
  plugin 'squirrel', :git => 'git://github.com/thoughtbot/squirrel.git'
  plugin 'hoptoad_notifier', :git => 'git://github.com/thoughtbot/hoptoad_notifier.git'
  plugin 'limerick_rake', :git => 'git://github.com/thoughtbot/limerick_rake.git'
  plugin 'mile_marker', :git => 'git://github.com/thoughtbot/mile_marker.git'
  
  initializer 'hoptoad.rb' do 
    HoptoadNotifier.configure do |config|
      config.api_key = 'HOPTOAD-KEY'
    end
  end
  
  initializer 'action_mailer_configs.rb' do
    ActionMailer::Base.smtp_settings = {
        :address => "smtp.thoughtbot.com",
        :port    => 25,
        :domain  => "thoughtbot.com"
    }
  end
  
  initializer 'requires.rb' do
    require 'redcloth'

    Dir[File.join(RAILS_ROOT, 'lib', 'extensions', '*.rb')].each do |f|
      require f
    end

    Dir[File.join(RAILS_ROOT, 'lib', '*.rb')].each do |f|
      require f
    end

    # Rails 2 doesn't like mocks

    Dir[File.join(RAILS_ROOT, 'test', 'mocks', RAILS_ENV, '*.rb')].each do |f|
      require f
    end
  end
  
  initializer 'time_formats.rb' do
    # Example time formats
    { :short_date => "%x", :long_date => "%a, %b %d, %Y" }.each do |k, v|
      ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.update(k => v)
    end
  end
end