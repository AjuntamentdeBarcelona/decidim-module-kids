# frozen_string_literal: true

module Decidim
  module Kids
    module System
      module OrganizationFormOverride
        extend ActiveSupport::Concern
        include Decidim::AttributeObject::TypeMap

        included do
          attribute :enable_minors_participation, Boolean, default: Decidim::Kids.enable_minors_participation.present?
          attribute :minimum_minor_age, Integer, default: Decidim::Kids.minimum_minor_age.to_i
          attribute :minimum_adult_age, Integer, default: Decidim::Kids.minimum_adult_age.to_i

          validates :minimum_minor_age, numericality: { greater_than: 0 }, if: ->(form) { form.enable_minors_participation.present? }
          validates :minimum_adult_age, numericality: { greater_than: 0 }, if: ->(form) { form.enable_minors_participation.present? }
          validate :minor_lower_than_adult, if: ->(form) { form.enable_minors_participation.present? }

          private

          def minor_lower_than_adult
            return if minimum_minor_age.to_i <= minimum_adult_age.to_i

            errors.add(:minimum_minor_age, :bigger_than_adult)
          end
        end
      end
    end
  end
end
