template(:bort) do
  plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git'
  plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git'
  plugin 'exception_notifier', :git => 'git://github.com/rails/exception_notification.git'
  plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git'
  plugin 'asset_packager', :git => 'http://synthesis.sbecker.net/pages/asset_packager'
  plugin 'role_requirement', :git => 'git://github.com/timcharper/role_requirement.git'
  plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'
  
  gem 'will-paginate', :git => 'git://github.com/mislav/will_paginate.git'
  gem 'rubyist-aasm'
  gem 'ruby-openid'
  
  generate("authenticated", "user session")
  generate("rspec")
end