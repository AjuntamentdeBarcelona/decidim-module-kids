# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/kids/version"

Gem::Specification.new do |s|
  s.version = Decidim::Kids::VERSION
  s.authors = ["Ivan Vergés"]
  s.email = ["ivan@pokecode.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/AjuntamentdeBarcelona/decidim-module-kids"
  s.metadata = {
    "bug_tracker_uri" => "https://github.com/AjuntamentdeBarcelona/decidim-module-kids/issues",
    "source_code_uri" => "https://github.com/AjuntamentdeBarcelona/decidim-module-kids"
  }
  s.required_ruby_version = ">= 3.0"

  s.name = "decidim-kids"
  s.summary = "A decidim for kids module"
  s.description = "A module for promoting kids participation in Decidim."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Kids::COMPAT_DECIDIM_VERSION
end
