# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe CreateMinorAccount do
    describe "call" do
      let!(:current_user) { create(:user, :confirmed) }

      let!(:form) do
        Decidim::Kids::MinorAccountForm.new(form_params)
      end

      let!(:command) { described_class.new(form, current_user) }

      let(:form_params) do
        {
          name: "Mike",
          email: "test@example.com",
          birthday: "01/11/2009",
          password: "password123456",
          password_confirmation: "password123456",
          tos_agreement: true
        }
      end

      it "broadcasts :ok and creates the minor" do
        expect { command.call }.to broadcast(:ok)
      end
    end
  end
end
