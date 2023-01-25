# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe CreateMinorAccount do
    describe "call" do
      let!(:current_user) { create(:user, :confirmed) }

      let!(:form) do
        Decidim::Kids::MinorAccountForm.from_params(form_params)
      end

      let!(:command) { described_class.new(form, current_user) }

      let!(:form_params) do
        {
          name: "Mike",
          email: "test@example.com",
          birthday: "01/11/2009",
          tos_agreement: true
        }
      end

      let(:last_user) { Decidim::User.last }

      before do
        allow(Rails.logger).to receive(:tagged).and_call_original
      end

      describe "when the form is valid" do
        it "broadcasts :ok and creates the minor" do
          expect { command.call }.to broadcast(:ok)
        end

        it "creates a new user" do
          expect { command.call }.to change(Decidim::User, :count).by(1)
          expect(last_user).to be_minor
          expect(last_user.name).to eq("Verification pending minor account")
          expect(last_user.minor_data.name).to eq("Mike")
        end

        it "creates a new minor's account" do
          expect { command.call }.to change(MinorAccount, :count).by(1)
        end

        it "writes log with consent" do
          command.call
          expect(Rails.logger).to have_received(:tagged).with(/MINOR-CONSENT/)
        end
      end

      describe "when the form is not valid" do
        before do
          allow(form).to receive(:invalid?).and_return(true)
        end

        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end

        it "doesn't create a user" do
          expect do
            command.call
          end.not_to change(Decidim::User, :count)
        end

        it "doesn't create a minor's account" do
          expect do
            command.call
          end.not_to change(Decidim::Kids::MinorAccount, :count)
        end

        it "doesn't write log with consent" do
          command.call
          expect(Rails.logger).not_to have_received(:tagged).with(/MINOR-CONSENT/)
        end
      end
    end
  end
end
