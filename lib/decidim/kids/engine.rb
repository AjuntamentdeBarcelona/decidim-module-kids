# frozen_string_literal: true

require "rails"
require "decidim/core"
require "deface"

module Decidim
  module Kids
    # This is the engine that runs on the public interface of kids.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Kids

      routes do
        # Add engine routes here
        # resources :kids
        # root to: "kids#index"
      end

      config.to_prepare do
        # Non-controller overrides here
        Decidim::Admin::Permissions.include(Decidim::Kids::Admin::PermissionsOverride)
        Decidim::Organization.include(Decidim::Kids::OrganizationOverride)
        Decidim::StaticPage.include(Decidim::Kids::StaticPageOverride)
        Decidim::System::RegisterOrganizationForm.include(Decidim::Kids::System::OrganizationFormOverride)
        Decidim::System::UpdateOrganizationForm.include(Decidim::Kids::System::OrganizationFormOverride)
        Decidim::System::UpdateOrganization.include(Decidim::Kids::System::UpdateOrganizationOverride)
        Decidim::System::RegisterOrganization.include(Decidim::Kids::System::RegisterOrganizationOverride)
      end

      # initializer "decidim_kids.overrides", after: "decidim.action_controller" do
      #   config.to_prepare do
      #     # Controller overrides here
      #   end
      # end

      initializer "decidim_kids.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
