# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe UpdateMinorAccount do
    let(:organization) { create :organization }
    let(:user) { create(:user, :confirmed, organization:) }
    # let!(:minor) { create(:minor, name: "Pending verification minor", tutor: user, organization:) }
    let(:command) { described_class.new(form, minor) }
    let!(:minor_data) { create(:minor_data, name: "Marco", email: "marco@example.org", birthday: "01/11/2010") }
    let!(:minor) { create(:minor, name: "Pending verification minor", tutor: user, organization:, minor_data:) }
    # let(:minor_data) do
    #   {
    #     name:,
    #     email:,
    #     birthday:
    #   }
    # end

    let(:form) do
      MinorAccountForm.from_params(
        name:,
        email:,
        birthday:,
        tos_agreement:
      )
    end

    let(:name) { "Marco" }
    let(:email) { "marco@example.org" }
    let(:birthday) { "01/11/2010" }
    let(:tos_agreement) { true }

    context "when valid" do
      it "updates the user's name" do
        form.name = "Marco New"

        expect do
          command.call
        end.to change { minor.minor_data.reload.name }.from("Marco").to("Marco New")

        expect(minor.reload.name).to eq("Pending verification minor")
      end

      it "updates the user's birthday" do
        form.birthday = 11.years.ago
        date = form.birthday

        expect { command.call }.to broadcast(:ok)
        expect(minor.minor_data.reload.birthday).to eq(date)
      end

      describe "updating the email" do
        before do
          form.email = "new@email.com"
        end

        it "broadcasts ok" do
          expect { command.call }.to broadcast(:ok)
          expect(minor.minor_data.reload.email).to eq("new@email.com")
          expect(minor.reload.email).to eq("new@email.com")
        end

        it "sends a confirmation email" do
          expect do
            perform_enqueued_jobs { command.call }
          end.to broadcast(:ok)
          expect(last_email.to).to include("new@email.com")
        end
      end
    end

    context "when invalid" do
      before do
        allow(form).to receive(:valid?).and_return(false)
      end

      it "doesn't update anything" do
        form.name = "John"
        old_name = minor.name
        expect { command.call }.to broadcast(:invalid)
        expect(minor.reload.name).to eq(old_name)
      end
    end
  end
end
