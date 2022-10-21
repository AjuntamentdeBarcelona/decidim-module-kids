# frozen_string_literal: true

require "spec_helper"
require "shared/command_minors_organization_examples"

module Decidim::System
  describe RegisterOrganization do
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
          minimum_adult_age:,
          minors_authorization:
        }
      end
      let(:enable_minors_participation) { true }
      let(:minimum_minor_age) { 9 }
      let(:minimum_adult_age) { 15 }
      let(:minors_authorization) { "id_documents" }

      it_behaves_like "valid command"
      it_behaves_like "creates minors configuration"
    end
  end
end
