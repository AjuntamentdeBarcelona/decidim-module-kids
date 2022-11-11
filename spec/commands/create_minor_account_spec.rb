# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe CreateMinorAccount do
    describe "call" do
      let(:form) do
        Decidim::Kids::MinorAccountForm.new(params)
      end

      let(:command) { described_class.new(form, current_user) }
      let(:params) do
        {
          name: "Mike",
          email: "test@example.com",
          birthday: "01/11/2009",
          password: "testpassword123456",
          confirmation_password: "testpassword123456",
          tos_agreement: true
        }

        it "returns a valid response" do
          expect { command.call }.to broadcast(:ok)
        end
      end
    end
  end
end
