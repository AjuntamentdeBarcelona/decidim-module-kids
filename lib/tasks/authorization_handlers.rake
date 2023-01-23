# frozen_string_literal: true

require "decidim/gem_manager"

namespace :decidim_kids do
  namespace :install do
    desc "Installs example authorization handler for minors with birthday metadata"
    task handlers: :environment do
      raise "Decidim gem is not installed" if decidim_path.nil?

      copy_kids_file "lib/decidim/kids/templates/dummy_age_authorization_handler.rb", "app/services/dummy_age_authorization_handler.rb"
      copy_kids_file "lib/decidim/kids/templates/verifications_initializer.rb", "config/initializers/decidim_kids_verifications.rb"
    end

    def copy_kids_file(origin_path, destination_path = origin_path)
      FileUtils.cp kids_path.join(origin_path), rails_app_path.join(destination_path), verbose: true
    end

    def kids_path
      @kids_path ||= Pathname.new(kids_gemspec.full_gem_path) if Gem.loaded_specs.has_key?(gem_name)
    end

    def kids_gemspec
      @kids_gemspec ||= Gem.loaded_specs[gem_name]
    end

    def rails_app_path
      @rails_app_path ||= Rails.root
    end

    def gem_name
      "decidim-kids"
    end
  end
end
