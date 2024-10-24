# frozen_string_literal: true

require "spec_helper"
require "shared/command_minors_organization_examples"

module Decidim::System
  describe CreateOrganization do
    describe "call" do
      let(:form) do
        RegisterOrganizationForm.new(params)
      end

      let(:command) { described_class.new(form) }
      let(:params) do
        {
          name: "Gotham City",
          host: "decide.gotham.gov",
          default_locale: "en",
          available_locales: ["en"],
          organization_admin_name: "John Smith",
          organization_admin_email: "john@smith.tld",
          reference_prefix: "GC",
          users_registration_mode: "existing",
          file_upload_settings: Decidim::OrganizationSettings.default(:upload),
          enable_minors_participation:,
          minimum_minor_age:,
          maximum_minor_age:,
          minors_authorization:,
          tutors_authorization:,
          maximum_minor_accounts:
        }
      end
      let(:enable_minors_participation) { true }
      let(:minimum_minor_age) { 9 }
      let(:maximum_minor_age) { 14 }
      let(:maximum_minor_accounts) { 4 }
      let(:minors_authorization) { "another_dummy_authorization_handler" }
      let(:tutors_authorization) { "another_dummy_authorization_handler" }

      it_behaves_like "valid command"
      it_behaves_like "creates minors configuration"
    end
  end
end
