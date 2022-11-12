# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe UpdateMinorAccount do
    describe "call" do
      let!(:current_user) { create(:user, :confirmed) }
      let(:minor) { create(:minor, tutor: current_user, organization: current_user.organization) }
      let(:data) do
        {
          name: minor.name,
          email: minor.email,
          birthday: 9.years.ago,
          password: "password123456",
          password_confirmation: "password123456"
        }
      end

      let!(:form) do
        MinorAccountForm.from_params(
          name: data[:name],
          email: data[:email],
          password: data[:password],
          password_confirmation: data[:password],
          birthday: data[:birthday],
          tos_agreement: true
        )
      end

      let!(:command) { described_class.new(form, minor) }

      context "when valid" do
        it "updates the user's name" do
          form.name = "Marco"

          expect { command.call }.to broadcast(:ok)
          expect(minor.reload.name).to eq("Marco")
        end

        it "updates the user's birthday" do
          form.birthday = 8.years.ago
          date = form.birthday

          expect { command.call }.to broadcast(:ok)
          expect(minor.minor_data.reload.birthday).to eq(date)
        end

        describe "when the password is present" do
          before do
            form.password = "decidim123123123"
            form.password_confirmation = "decidim123123123"
          end

          it "updates the password" do
            expect { command.call }.to broadcast(:ok)
            expect(minor.reload.valid_password?("decidim123123123")).to be(true)
          end
        end

        describe "updating the email" do
          before do
            form.email = "new@email.com"
          end

          it "broadcasts ok" do
            expect { command.call }.to broadcast(:ok)
          end

          it "sends a reconfirmation email" do
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
end
