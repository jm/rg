rg
    by Jeremy McAnally
    jeremy@entp.com

== DESCRIPTION:

Generate Rails applications from your own template!

== FEATURES/PROBLEMS:

* Generate a Rails application from a template, including plugins, vendored gems, lib files, initializers, etc.
* Includes a solid list of built-in templates
* Save yourself the hassle of keeping your core components up to date (coming soon)
* Install system wide templates
* Pull templates in from files, stdin, and straight from a Gist (http://gist.github.com/).

== SYNOPSIS:

Here's a really random example; checkout the documentation for Rg::Runner to see what each 
method can do.  You can also check out the builtin/ directory to see some solid examples.

    template :thing, "Describe it here" do
      # Install some plugins
      plugin("thing", :git => "git://www.github.com/dudette/thing.git")
      
      # Vendor some gems
      gem("name")
      gem("name", :git => "git://github.com/dude/name.git")
      
      lib("path/to/file.rb") do
        put_some_code(:here)
      end
  
      task :thing do
        # blah
      end
  
      rakefile "file.rake" do
        desc "blah"
        task :hoohah do
          puts "hi"
        end
      end
      
      generate("migration", "add_field_to_table thing:string")
    end

== REQUIREMENTS:

* ruby2ruby if you want to use the built-in templates and/or the fancy code block dumping

== INSTALL:

* sudo gem install jeremymcanally-rg

== LICENSE:

(The MIT License)

Copyright (c) 2008 FIXME (different license?)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
