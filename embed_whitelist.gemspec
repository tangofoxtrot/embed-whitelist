# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{embed_whitelist}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Richard Luther"]
  s.date = %q{2009-02-25}
  s.description = %q{Simple plugin for sanitizing embed widgets. Uses a white list approach for tags, attributes, and domains. I will be adding to the list of allowed domains.}
  s.email = ["richard@tangofoxtrot.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/embed_whitelist.rb", "lib/embed_whitelist/embed_whitelist_config.yml", "script/console", "script/destroy", "script/generate", "test/test_embed_whitelist.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{FIX (url)}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{embed_whitelist}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple plugin for sanitizing embed widgets}
  s.test_files = ["test/test_embed_whitelist.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.2.3"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
