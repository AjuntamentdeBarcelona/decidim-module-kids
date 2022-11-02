# frozen_string_literal: true

namespace :decidim_kids do
  desc "Create default minors account static page"
  task create_default_page: :environment do
    Decidim::Organization.find_each do |organization|
      Decidim::System::CreateDefaultPages.call(organization)
    end
  end
end
