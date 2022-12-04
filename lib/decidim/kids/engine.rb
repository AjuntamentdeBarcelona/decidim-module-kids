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
        authenticate(:user) do
          resources :user_minors do
            collection do
              get :unverified
            end
            member do
              post :resend_invitation_to_minor, to: "user_minors#resend_invitation_to_minor"
            end
            resources :authorizations, only: [:new, :create, :index] do
              # collection do
              #   get :renew_modal
              #   get :renew
              # end
            end
            resources :minor_impersonations, controller: "minor_impersonations", only: [:new, :create] do
              collection do
                post :close_session
              end
            end
          end
        end
      end

      config.to_prepare do
        # Non-controller overrides here
        Decidim::Admin::Permissions.include(Decidim::Kids::Admin::PermissionsOverride)
        Decidim::Organization.include(Decidim::Kids::OrganizationOverride)
        Decidim::User.include(Decidim::Kids::UserOverride)
        Decidim::StaticPage.include(Decidim::Kids::StaticPageOverride)
        Decidim::System::RegisterOrganizationForm.include(Decidim::Kids::System::OrganizationFormOverride)
        Decidim::System::UpdateOrganizationForm.include(Decidim::Kids::System::OrganizationFormOverride)
        Decidim::System::UpdateOrganization.include(Decidim::Kids::System::UpdateOrganizationOverride)
        Decidim::System::RegisterOrganization.include(Decidim::Kids::System::RegisterOrganizationOverride)
      end

      initializer "decidim_kids.overrides", after: "decidim.action_controller" do
        config.to_prepare do
          Decidim::ApplicationController.include(Decidim::Kids::ImpersonateMinors)
          Decidim::DeviseControllers.include(Decidim::Kids::ImpersonateMinors)
        end
      end

      initializer "decidim_kids.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_kids.user_menu" do
        Decidim.menu :user_menu do |menu|
          menu.add_item :minor_accounts,
                        t("menu", scope: "decidim.kids.user"),
                        decidim_kids.user_minors_path,
                        position: 1.4,
                        if: allowed_to?(:index, :minor_accounts, {}, [::Decidim::Kids::Permissions], current_user)
        end
      end
    end
  end
end

# Engines to handle logic unrelated to participatory spaces or components need to be registered independently
Decidim.register_global_engine(
  :decidim_kids, # this is the name of the global method to access engine routes,
  # can't use decidim_donations as is the one assigned by the verification engine
  ::Decidim::Kids::Engine,
  at: "/decidim_kids"
)
