# frozen_string_literal: true

module Decidim
  module Kids
    module Admin
      # Base Controller that specific participatory spaces should inherit from to limit access to minors.
      class MinorsSpaceController < Decidim::Admin::ApplicationController
        before_action do
          enforce_permission_to :manage, :space_minors_configuration
        end

        helper_method :access_types, :authorization_handlers, :authorization_method_error

        def index
          @form = form(MinorsSpaceForm).from_model(current_participatory_space_config)
        end

        def create
          @form = form(MinorsSpaceForm).from_params(params)

          SaveParticipatorySpaceConfig.call(@form, current_participatory_space) do
            on(:ok) do
              flash[:notice] = I18n.t("minors_space.save.success", scope: "decidim.kids.admin")
              redirect_to action: :index
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("minors_space.save.error", scope: "decidim.kids.admin", errors: @form&.errors&.messages&.values&.flatten&.first)
              render :index
            end
          end
        end

        private

        def current_participatory_space_config
          @current_participatory_space_config ||= MinorsSpaceConfig.for(current_participatory_space)
        end

        def authorization_handlers
          Decidim::Kids.valid_minor_workflows.pluck(:description, :name)
        end

        def authorization_method_error(handler)
          form_class = Decidim::Verifications.find_workflow_manifest(handler)&.form&.safe_constantize
          return :invalid unless form_class

          dummy = form_class.new
          return :metadata unless dummy.respond_to? :metadata

          :metadata unless Decidim::Kids.minor_authorization_age_attributes.detect { |attr| dummy.metadata.has_key?(attr.to_sym) }
        end

        def access_types
          {
            t("minors_space.form.all", scope: "decidim.kids.admin") => "all",
            t("minors_space.form.minors", scope: "decidim.kids.admin") => "minors"
          }
        end
      end
    end
  end
end
