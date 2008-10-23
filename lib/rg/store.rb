require 'fcntl'
require 'open-uri'

module Rg
  # Keeps track of user-specific rgfiles.  Gives us an easy interface for installing
  # and managing them.  This files lives in ~/.rgfile ($HOMEPATH/rg.file on Windows).
  class Store
    class <<self
      # Install a new rg template.  You can install one of three ways:
      #   1. From STDIN...
      #
      #       $ rg -i < wget http://www.mysite.com/my_template.rb
      #
      #   2. From a file...
      #
      #       $ rg -i template.rb
      #
      #   3. Straight from Gist (http://gist.github.com)
      #
      #       $ rg -i http://gist.github.com/1337.txt
      #       $ rg -i gist:42
      #
      def install(args, stdin)
        # Kill off -i
        args.shift
        code = nil
        
        if stdin.fcntl(Fcntl::F_GETFL, 0) == 0
          code = stdin.read
        else
          if args[0] =~ /^http:\/\/gist.github.com\// 
            id = args[0].match(/^http:\/\/gist.github.com\/(.*)/)[1]
            code = open("http://gist.github.com/#{id}.txt").read
          elsif args[0] =~ /^gist:/
            id = args[0].match(/^gist:(.*)/)[1].strip
            code = open("http://gist.github.com/#{id}.txt").read
          else
            code = File.open(args[0]).read
          end
        end
        
        if code.nil?
          raise "No rg template found!"
        else
          write(code.strip + "\n\n")
        end
      end
      
      # Write template data to the store
      def write(data)
        File.open(path, 'a+') {|f| f.write(data)}
      end
      
      # Read the stored data in ~/.rgfile
      def read
        File.open(path, 'r').read
      end
      
      # Get the path to the rgfile
      def path
        path = if (PLATFORM =~ /win32/)
          win32_path
        else
          File.join(File.expand_path('~'), '.rgfile')
        end
        FileUtils.touch(path)
        path
      end

      def win32_path #:nodoc:
        unless File.exists?(win32home = ENV['HOMEDRIVE'] + ENV['HOMEPATH'])
          puts "No HOMEDRIVE or HOMEPATH environment variable!" 
        else
          File.join(win32home, 'rg.file')
        end
      end
    end 
  end
end