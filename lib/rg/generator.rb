module Rg
  class Generator
    class <<self
      attr_accessor :templates
    end
    
    def initialize
      Generator.templates ||= {}
    end
    
    # Main run method.
    def run(name, args)
      # Parse out the arguments
      arg_string, generator_args = handle_args(args)
      
      # Generate the application using the rails binscript
      puts "generating app"
      system("rails --quiet #{arg_string} #{name}")
      raise "Rails couldn't generate your application!" unless $?.exitstatus == 0
      
      puts "applying #{@template} template"
      Dir.chdir(name)
      @root = Dir.pwd

      @runner = Runner.new(@root)
      activate_templates
      
      # Template found?  Cool.  No?  FAIL.
      if Generator.templates[@template.to_sym]
        Generator.templates[@template.to_sym][1].call
      else
        raise "That template isn't installed!"
      end
    end
    
    # This is sort of ugly, but it parses out the arguments we want to keep and the arguments
    # that go to Rails' bin.
    def handle_args(args)
      rails = ""
      generators = []
      
      # Don't complain about for here.  There's a reason for it.
      for arg in args
        case args.shift
        when "-f", "--freeze"
          rails += "--freeze "
        when "-d"
          rails += "--database=\"#{args.shift}\" "
        when "-r"
          rails += "--ruby=\"#{args.shift}\" "
        when "-t"
          @template = args.shift
        else
          if arg =~ /^--database=/
            rails += "--database=#{arg.gsub(/^--database=/, '')}"
          elsif arg =~ /^--ruby=/
            rails += "--ruby=#{arg.gsub(/^--ruby=/, '')}"
          elsif arg =~ /^--template=/
            @template = arg.gsub(/^--template=/, '')
          else
            generators << arg
          end
        end
      end
      
      return [rails, generators]
    end
    
    def activate_templates
      # Grab all the built in templates
      Dir.glob(File.dirname(__FILE__) + "/../builtin/*.rb").sort.each do |template|
        code = File.open(template, "r") {|f| f.read}
        @runner.instance_eval(code)
      end
      
      # Pull in user-specific templates that live in ~/.rgfile
      @runner.instance_eval(Store.read)
    end
  end
end