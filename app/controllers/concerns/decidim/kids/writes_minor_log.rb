# frozen_string_literal: true

module Decidim
  module Kids
    module WritesMinorLog
      extend ActiveSupport::Concern

      included do
        before_action do
          Rails.logger.tagged("MINORS-ACTIVITY").info(log_params) if current_user.present? && current_user.minor?
        end

        private

        def log_params
          {
            remote_ip: request.remote_ip,
            method: request.method,
            path: request.fullpath,
            params: request.params,
            format: request.format&.to_s || "*/*",
            user_id: current_user.id
          }
        end
      end
    end
  end
end
