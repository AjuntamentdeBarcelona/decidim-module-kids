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

    # Default value for the legal age of consent to create a minor account without parental permission
    config_accessor :minimum_adult_age do
      14
    end
  end
end
