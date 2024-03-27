# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids::Admin
  describe SaveParticipatorySpaceConfig do
    describe "call" do
      let!(:form) do
        MinorsSpaceForm.from_params(form_params)
      end

      let!(:command) { described_class.new(form, participatory_space) }
      let(:participatory_space) { create(:participatory_process) }
      let!(:form_params) do
        {
          access_type: "minors",
          authorization: "dummy_authorization_handler",
          max_age: 17,
          participatory_space:
        }
      end

      let(:last_conf) { Decidim::Kids::MinorsSpaceConfig.last }

      describe "when the form is invalid" do
        before do
          allow(form).to receive(:invalid?).and_return(true)
        end

        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end
      end

      describe "when no participatory_space" do
        let(:participatory_space) { nil }

        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end
      end

      describe "when the form is valid" do
        it "broadcasts :ok and creates the config" do
          expect { command.call }.to broadcast(:ok)
        end

        it "creates a new config" do
          expect { command.call }.to change(Decidim::Kids::MinorsSpaceConfig, :count).by(1)
          expect(last_conf.access_type).to eq("minors")
          expect(last_conf.authorization).to eq("dummy_authorization_handler")
          expect(last_conf.max_age).to eq(17)
          expect(last_conf.participatory_space).to eq(participatory_space)
        end

        context "when the config already exists" do
          let!(:existing_config) { create(:minors_space_config, participatory_space:) }

          it "broadcasts :ok and updates the config" do
            expect { command.call }.to broadcast(:ok)
          end

          it "updates the config" do
            expect { command.call }.not_to change(Decidim::Kids::MinorsSpaceConfig, :count)
            expect(last_conf.access_type).to eq("minors")
            expect(last_conf.authorization).to eq("dummy_authorization_handler")
            expect(last_conf.max_age).to eq(17)
            expect(last_conf.participatory_space).to eq(participatory_space)
          end
        end
      end
    end
  end
end
