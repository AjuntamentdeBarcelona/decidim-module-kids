# frozen_string_literal: true

module Decidim
  module Kids
    module UserOverride
      extend ActiveSupport::Concern

      included do
        # todo: extract this value from the database
        def minor?
          false
        end
      end
    end
  end
end
