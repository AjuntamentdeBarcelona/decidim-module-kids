# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/system/test/factories"

FactoryBot.define do
  factory :minors_organization_config, class: "Decidim::Kids::OrganizationConfig" do
    organization
    enable_minors_participation { true }
    minimum_minor_age { 10 }
    minimum_adult_age { 14 }
    authorization { "id_documents" }
  end
end
