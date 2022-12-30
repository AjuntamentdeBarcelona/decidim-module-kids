# frozen_string_literal: true

Decidim::Verifications.register_workflow(:dummy_age_authorization_handler) do |workflow|
  workflow.form = "DummyAgeAuthorizationHandler"
  workflow.expires_in = 1.month
  workflow.renewable = true
  workflow.time_between_renewals = 5.minutes
end
