# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{roker}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Greg Sterndale"]
  s.date = %q{2009-12-05}
  s.description = %q{Weather forecasts from weather.gov}
  s.email = %q{gsterndale@gmail.com}
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
     "lib/numeric.rb",
     "lib/roker.rb",
     "lib/time.rb",
     "lib/time_layout.rb",
     "lib/time_span.rb",
     "lib/weather_parameter.rb",
     "roker",
     "roker.gemspec",
     "test/helper.rb",
     "test/test_roker.rb",
     "test/test_time.rb",
     "test/test_time_layout.rb",
     "test/test_time_span.rb",
     "test/test_weather_parameter.rb",
     "test/weather_xml.xml"
  ]
  s.homepage = %q{http://github.com/gsterndale/roker}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Weather forecasts from weather.gov}
  s.test_files = [
    "test/helper.rb",
     "test/test_roker.rb",
     "test/test_time.rb",
     "test/test_time_layout.rb",
     "test/test_time_span.rb",
     "test/test_weather_parameter.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0.9.1"])
      s.add_development_dependency(%q<hpricot>, [">= 0.6.164"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0.9.1"])
      s.add_dependency(%q<hpricot>, [">= 0.6.164"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0.9.1"])
    s.add_dependency(%q<hpricot>, [">= 0.6.164"])
  end
end

