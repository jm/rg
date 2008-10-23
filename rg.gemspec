Gem::Specification.new do |s|
  s.name = %q{rg}
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy McAnally"]
  s.date = %q{2008-10-23}
  s.default_executable = %q{rg}
  s.description = %q{Generate Rails applications from your own template!}
  s.email = %q{jeremy@entp.com}
  s.executables = ["rg"]
  s.extra_rdoc_files = ["History.txt", "README.txt", "bin/rg"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/rg", "lib/builtin/bort.rb", "lib/builtin/entp.rb", "lib/builtin/thoughtbot.rb", "lib/rg.rb", "lib/rg/generator.rb", "lib/rg/runner.rb", "lib/rg/scm/git.rb", "lib/rg/scm/svn.rb", "lib/rg/store.rb", "spec/rg_spec.rb", "spec/spec_helper.rb", "tasks/ann.rake", "tasks/bones.rake", "tasks/gem.rake", "tasks/git.rake", "tasks/manifest.rake", "tasks/notes.rake", "tasks/post_load.rake", "tasks/rdoc.rake", "tasks/rubyforge.rake", "tasks/setup.rb", "tasks/spec.rake", "tasks/svn.rake", "tasks/test.rake", "test/test_rg.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://www.omgbloglol.com/}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rg}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Generate Rails applications from your own template!}
  s.test_files = ["test/test_rg.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<ruby2ruby>, ["> 0.0.0"])
      s.add_development_dependency(%q<bones>, [">= 2.1.1"])
    else
      s.add_dependency(%q<ruby2ruby>, ["> 0.0.0"])
      s.add_dependency(%q<bones>, [">= 2.1.1"])
    end
  else
    s.add_dependency(%q<ruby2ruby>, ["> 0.0.0"])
    s.add_dependency(%q<bones>, [">= 2.1.1"])
  end
end
