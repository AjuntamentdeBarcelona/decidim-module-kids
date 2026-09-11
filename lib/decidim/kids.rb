# frozen_string_literal: true

require "decidim/kids/admin"
require "decidim/kids/engine"
require "decidim/kids/admin_engine"

module Decidim
  module Kids
    autoload :AgeMethods, "decidim/kids/age_methods"

    class << self
      def config = self

      def configure
        yield self
      end
    end

    #######################################################
    # Default configurations for any organization
    # these setting can be overridden in /system admin conf
    #######################################################

    # If true, minor participation is enabled by default in any newly created organization
    mattr_accessor :enable_minors_participation, default: false

    # Default value for the minimum age required for a minor in order to create an account
    mattr_accessor :minimum_minor_age, default: 10

    # Default value for the maximum age of a person to be considered a minor (1 year than this number will consider the user an adult)
    mattr_accessor :maximum_minor_age, default: 13

    # Default value maximum number of minors that can be assigned to a tutor
    mattr_accessor :maximum_minor_accounts, default: 3

    # If true, the tutor can impersonate a minor
    mattr_accessor :allow_impersonation, default: true

    # Default authorization metadata attributes where the minor's birthday is stored
    # (if the authorization handler stores it)
    # If this value is present: In addition to the normal verification process for the minor, the
    #                           age of the minor returned by the validation will be enforced to be
    #                           between the minimum_minor_age and maximum_minor_age values.
    #                           Note that if the validation does not stores the birthday in one of these
    #                           attributes, the validation will always fail.
    # If this value is blank: No age checks will be performed (but the validation process might do it independently)
    mattr_accessor :minor_authorization_age_attributes, default: [:birthday, :date_of_birth, :birth_date, :birthdate]

    ######## End of system configurations ########

    # Participatory spaces that can be restricted to minors
    # This will add a menu item on the admin participatory space and will enable administrators to configure it
    # manifest and admin_menu must exist, otherwise will be ignored
    # For a new participatory space to work here a new controller must be created
    # under the participatory space namespace inheriting from Decidim::Kids::Admin::MinorsSpaceController
    mattr_accessor :participatory_spaces, default: [
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

    # Only one-step authorization workflows are supported
    def self.valid_minor_workflows
      Decidim.authorization_workflows.filter(&:form)
    end

    def self.valid_tutor_workflows
      Decidim.authorization_workflows
    end
  end
end
