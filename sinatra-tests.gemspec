# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sinatra-tests}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["kematzy"]
  s.date = %q{2009-09-04}
  s.email = %q{kematzy@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/sinatra/tests.rb",
     "lib/sinatra/tests/shared_specs.rb",
     "lib/sinatra/tests/test_case.rb",
     "sinatra-tests.gemspec",
     "spec/sinatra-test_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/kematzy/sinatra-tests}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Sinatra::Tests is a repository of common Test/RSpec helpers}
  s.test_files = [
    "spec/sinatra-test_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 0.10.1"])
      s.add_runtime_dependency(%q<rack-test>, [">= 0.4.1"])
      s.add_runtime_dependency(%q<rspec>, [">= 1.2.8"])
      s.add_runtime_dependency(%q<rspec_hpricot_matchers>, [">= 1.0.0"])
    else
      s.add_dependency(%q<sinatra>, [">= 0.10.1"])
      s.add_dependency(%q<rack-test>, [">= 0.4.1"])
      s.add_dependency(%q<rspec>, [">= 1.2.8"])
      s.add_dependency(%q<rspec_hpricot_matchers>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0.10.1"])
    s.add_dependency(%q<rack-test>, [">= 0.4.1"])
    s.add_dependency(%q<rspec>, [">= 1.2.8"])
    s.add_dependency(%q<rspec_hpricot_matchers>, [">= 1.0.0"])
  end
end
