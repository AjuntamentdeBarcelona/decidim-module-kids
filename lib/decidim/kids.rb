# frozen_string_literal: true

require "decidim/kids/admin"
require "decidim/kids/engine"
require "decidim/kids/admin_engine"

module Decidim
  module Kids
    include ActiveSupport::Configurable

    #######################################################
    # Default configurations for any organization
    # these setting can be overridden in /system admin conf
    #######################################################

    # If true, minor participation is enabled by default in any newly created organization
    config_accessor :enable_minors_participation do
      false
    end

    # Default value for the minimum age required for a minor in order to create an account
    config_accessor :minimum_minor_age do
      10
    end

    # Default value for the maximum age of a person to be considered a minor (1 year than this number will consider the user an adult)
    config_accessor :maximum_minor_age do
      13
    end

    # Default value maximum number of minors that can be assigned to a tutor
    config_accessor :maximum_minor_accounts do
      3
    end

    ######## End of system configurations ########

    # Default authorization metadata attributes where the minor's birthday is stored
    # (if the authorization handler stores it)
    # If this value is present: In addition to the normal verification process for the minor, the
    #                           age of the minor returned by the validation will be enforced to be
    #                           between the minimum_minor_age and maximum_minor_age values.
    #                           Note that if the validation does not stores the birthday in one of these
    #                           attributes, the validation will always fail.
    # If this value is blank: No age checks will be performed (but the validation process might do it independently)
    config_accessor :minor_authorization_age_attributes do
      [:birthday, :date_of_birth, :birth_date, :birthdate]
    end

    # Participatory spaces that can be restricted to minors
    # This will add a menu item on the admin participatory space and will enable administrators to configure it
    # manifest and admin_menu must exist, otherwise will be ignored
    # For a new participatory space to work here a new controller must be created
    # under the participatory space namespace inheriting from Decidim::Kids::Admin::MinorsSpaceController
    config_accessor :participatory_spaces do
      [
        {
          manifest: :assemblies,
          # From the routes specified in the admin_engine.rb of the participatory space module:
          admin_menu: :admin_assembly_menu,
          admin_scope: "/assemblies/", # this is used to generate the prefix of the admin url,
          # needs to match other subcontrollers (like categories)
          admin_slug: :assembly_slug # the slug will be added to the admin_scope to place the additional controller
          # under the management of the participatory spaces, the slug name must match the admin_engine.rb routes
        },
        {
          manifest: :participatory_processes,
          admin_menu: :admin_participatory_process_menu,
          admin_scope: "/participatory_processes/",
          admin_slug: :participatory_process_slug
        }
      ]
    end

    # Only one-step authorization workflows are supported
    def self.valid_minor_workflows
      Decidim.authorization_workflows.filter(&:form)
    end

    def self.valid_tutor_workflows
      Decidim.authorization_workflows
    end
  end
end
