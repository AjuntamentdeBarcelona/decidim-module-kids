# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe CreateMinorAccount do
    describe "call" do
      let!(:organization) { create(:organization) }
      let!(:tutor) { create(:user, :confirmed, organization:) }
      let!(:minor) { Decidim::User.new(user_params) }
      let!(:minor_data) { MinorData.new(minor_data_params) }
      let!(:minor_account) do
        {
          tutor:,
          minor:
        }
      end

      let!(:form) do
        MinorAccountForm.new(form_params)
      end

      let!(:command) { described_class.new(form, tutor) }

      let(:form_params) do
        {
          name: "Mike",
          email: "test@example.com",
          birthday: "01/11/2009",
          password: "testpassword123456",
          password_confirmation: "testpassword123456",
          tos_agreement: true
        }
      end

      let(:user_params) do
        {
          email: "test@example.com",
          name: "Mike",
          organization:,
          password: "testpassword123456",
          password_confirmation: "testpassword123456",
          nickname: "Mike",
          tos_agreement: true,
          blocked: true,
          minor_data:
        }
      end

      let(:minor_data_params) do
        {
          name: "Mike",
          email: "test@example.com",
          birthday: "01/11/2009",
          password: "testpassword123456"
        }
      end

      it "returns a valid response" do
        expect { command.call }.to broadcast(:ok)
      end
    end
  end
end
