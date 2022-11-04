# frozen_string_literal: true

module Decidim
  module Kids
    class ApplicationController < Decidim::ApplicationController
      def permission_class_chain
        [::Decidim::Kids::Permissions] + super
      end
    end
  end
end
