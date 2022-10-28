# frozen_string_literal: true

require "spec_helper"
require "shared/command_minors_organization_examples"

module Decidim::System
  describe UpdateOrganization do
    describe "call" do
      let(:form) do
        UpdateOrganizationForm.new(params)
      end

      let(:organization) { create :organization }
      let(:command) { described_class.new(organization.id, form) }
      let(:params) do
        {
          name: "Gotham City",
          host: "decide.gotham.gov",
          users_registration_mode: "existing",
          file_upload_settings: Decidim::OrganizationSettings.default(:upload),
          enable_minors_participation:,
          minimum_minor_age:,
          minimum_adult_age:,
          minors_authorization:,
          tutors_authorization:
        }
      end
      let(:enable_minors_participation) { true }
      let(:minimum_minor_age) { 9 }
      let(:minimum_adult_age) { 15 }
      let(:minors_authorization) { "dummy_authorization_handler" }
      let(:tutors_authorization) { "id_documents" }

      it_behaves_like "valid command"
      it_behaves_like "saves minors configuration"

      context "when minors config already exists" do
        let!(:minors_organization_config) do
          create(:minors_organization_config,
                 organization:,
                 enable_minors_participation: false,
                 minimum_minor_age: 10,
                 minimum_adult_age: 14,
                 minors_authorization: "another_dummy_authorization_handler",
                 tutors_authorization: "another_dummy_authorization_handler")
        end

        it_behaves_like "saves minors configuration"
      end
    end
  end
end
