# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  load 'tasks/setup.rb'
end

ensure_in_path 'lib'
require 'rg'

task :default => 'spec:run'

PROJ.name = 'rg'
PROJ.authors = 'Jeremy McAnally'
PROJ.email = 'jeremy@entp.com'
PROJ.url = 'http://www.omgbloglol.com/'
PROJ.version = Rg::VERSION
PROJ.rubyforge.name = 'rg'

PROJ.gem.dependencies << ['ruby2ruby', '> 0.0.0']

PROJ.spec.opts << '--color'

# EOF
