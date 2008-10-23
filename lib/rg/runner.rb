require File.dirname(__FILE__) + '/scm/git'
require File.dirname(__FILE__) + '/scm/svn'

module Rg
  class Runner
    attr_reader :behavior, :description
    
    def initialize(root) # :nodoc:
      @root = root
    end
    
    # Create a new rg template.  Name is required, description is optional.
    #
    # ==== Example
    #
    #     template(:rg) do
    #       # template logic here...
    #     end
    #
    #     template(:awesome, "I'm awesome!") do
    #       # template logic here...
    #     end
    #
    def template(name, description=nil, &block)
      Generator.templates[name.to_sym] = [description, block]
    end

    # Create a new file in the Rails project folder.  Specify the 
    # relative path from RAILS_ROOT.  Code can be specified in a block
    # or a data string can be given.
    #
    # ==== Examples
    #
    #     file("lib/fun_party.rb") do
    #       have_fun_party!
    #       self.go_home!
    #     end
    #
    #     file("config/apach.conf", "your apache config")
    #
    def file(filename, data=nil)
      puts "creating file #{filename}"
      in_root(File.dirname(filename)) do
        File.open("#{folder}/#{filename}", "w") do |f|
          if block_given?
            f.write(code_for(block))
          else
            f.write(data)
          end
        end
      end
    end
    
    # Install a plugin.  You must provide either an svn url or git url.
    #
    # ==== Examples
    #
    #     plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'
    #     plugin 'restful-authentication', :svn => 'svn://svnhub.com/technoweenie/restful-authentication/trunk'
    #
    def plugin(name, options)
      puts "installing plugin #{name}"
      in_root do
        if options[:svn] || options[:git]
          `script/plugin install #{options[:svn] || options[:git]}`
        else
          puts "! no git or svn provided for #{name}.  skipping..."
        end
      end
    end
    
    # Install a gem into vendor/gems.  You can install a gem in one of three ways:
    #
    #   1. Provide a git repository URL...
    #
    #       gem 'will-paginate', :git => 'git://github.com/mislav/will_paginate.git'
    #
    #   2. Provide a subversion repository URL...
    #
    #       gem 'will-paginate', :svn => 'svn://svnhub.com/mislav/will_paginate/trunk'
    #
    #   3. Provide a gem name and use your system sources to install and unpack it.
    #
    #       gem 'ruby-openid'
    #
    def gem(name, options={})
      puts "vendoring gem #{name}"
      if options[:git]
        in_root("vendor/gems") do
          Git.clone(options[:git], options[:branch])
        end
      elsif options[:svn]
        in_root("vendor/gems") do
          Svn.checkout(options[:svn], options[:branch])
        end
      else        
        # TODO: Gem dependencies.  Split output on \n, iterate lines looking for Downloaded...
        in_root("vendor/gems") do
          # Filename may be different than gem name
          filename = (`gem fetch #{name}`).chomp.gsub(/Downloaded /, '')

          `gem unpack #{filename}.gem`
          File.delete("#{filename}.gem")
        end
      end
    end
    
    # Create a new file in the vendor/ directory. Code can be specified 
    # in a block or a data string can be given.
    #
    # ==== Examples
    #
    #     vendor("borrowed.rb") do
    #       self.steal_code!
    #       self.place_in_vendor
    #     end
    #
    #     vendor("foreign.rb", "# Foreign code is fun")
    #
    def vendor(filename, data=nil, &block)
      puts "vendoring file #{filename}"
      in_root("vendor") do |folder|
        File.open("#{folder}/#{filename}", "w") do |f|
          if block_given?
            f.write(code_for(block))
          else
            f.write(data)
          end
        end
      end
    end
    
    # Create a new file in the lib/ directory. Code can be specified 
    # in a block or a data string can be given.
    #
    # ==== Examples
    #
    #     lib("borrowed.rb") do
    #       self.steal_code!
    #       self.place_in_vendor
    #     end
    #
    #     lib("foreign.rb", "# Foreign code is fun")
    #
    def lib(filename, data=nil)
      puts "add lib file #{filename}"
      in_root("lib") do |folder|
        File.open("#{folder}/#{filename}", "w") do |f|
          if block_given?
            f.write(code_for(block))
          else
            f.write(data)
          end
        end
      end
    end
    
    # Create a new Rake task in the lib/tasks/application.rake file. 
    # Code can be specified  in a block or a data string can be given.
    #
    # ==== Examples
    #
    #     task(:whatever) do
    #       puts "hi from rake"
    #     end
    #
    #     task(:go_away, "puts 'be gone!'")
    #
    def task(name, description=nil, &block)
      puts "adding task :#{name}"
      in_root("lib/tasks") do |folder|
        File.open("#{folder}/application.rake", "a+") do |f|
          if block_given?
            f.write(code_for(block))
          else
            f.write(data)
          end
        end
      end
    end
    
    # Create a new Rakefile with the provided code (either in a block or a string).
    #
    # ==== Examples
    #
    #    rakefile("bootstrap.rake") do
    #      task :bootstrap do 
    #        puts "i like boots!"
    #      end
    #    end
    # 
    #    rakefile("seed.rake", "puts 'im plantin ur seedz'")
    #
    def rakefile(filename, data=nil, &block)
      puts "adding rakefile #{filename}"
      in_root("lib/tasks") do |folder|
        File.open("#{folder}/#{filename}", "w") do |f|
          if block_given?
            f.write(code_for(block))
          else
            f.write(data)
          end
        end
      end
    end
    
    # Create a new initializer with the provided code (either in a block or a string).
    #
    # ==== Examples
    #
    #    initializer("globals.rb") do
    #      BEST_COMPANY_EVAR = :entp
    #    end
    # 
    #    initializer("api.rb", "API_KEY = '123456'")
    #
    def initializer(filename, data=nil, &block)
      puts "adding initializer #{filename}"
      in_root("config/initializers") do |folder|
        File.open("#{folder}/#{filename}", "w") do |f|
          if block_given?
            f.write(code_for(block))
          else
            f.write(data)
          end
        end
      end
    end
    
    # Generate something using a generator from Rails or a plugin.
    # The second parameter is the argument string that is passed to
    # the generator or an Array that is joined.
    #
    # ==== Example
    #
    #     generate(:authenticated, "user session")
    #
    def generate(what, args=nil)
      puts "generating #{what}"
      if args.class == Array
        args = args.join(" ")
      end
      
      in_root do
        `script/generate --quiet #{what} #{args}`
      end
    end
    
    protected
      # Do something in the root of the Rails application or 
      # a provided subfolder; the full path is yielded to the block you provide.
      # The path is set back to the previous path when the method exits.
      def in_root(subfolder=nil)
        folder = "#{@root}#{'/' + subfolder if subfolder}"
        
        Dir.mkdir(folder) unless File.exist?(folder)
        
        old_path = Dir.pwd
        Dir.chdir(folder)
        yield folder
        Dir.chdir(old_path)
      end
      
      # Massage the ruby2ruby output a little bit.
      def code_for(behavior)
        code = behavior.to_ruby
        code = code.gsub(/^proc \{/, '')
        code = code.gsub(/\}$/, '')
        
        # TODO_VERY_SOON: Remove spaces and junk from lines
        
        # TODO: Maybe one day switch all the {} procs 
        # to do/end if they're multi-line
        
        code
      end
  end
end