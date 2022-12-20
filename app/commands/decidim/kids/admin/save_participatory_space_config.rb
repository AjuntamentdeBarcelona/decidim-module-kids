# frozen_string_literal: true

module Decidim
  module Kids
    module Admin
      # A command to authorize a user with an authorization handler.
      class SaveParticipatorySpaceConfig < Decidim::Command
        def initialize(form, participatory_space)
          @form = form
          @participatory_space = participatory_space
        end

        def call
          return broadcast(:invalid) if participatory_space.blank?
          return broadcast(:invalid) if form.invalid?

          save_config

          broadcast(:ok)
        end

        private

        def save_config
          config = MinorsSpaceConfig.find_or_initialize_by(participatory_space:)
          config.update!(
            access_type: form.access_type,
            authorization: form.authorization,
            max_age: form.max_age
          )
        end

        attr_reader :form, :participatory_space
      end
    end
  end
end
