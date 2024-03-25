# frozen_string_literal: true

require "spec_helper"
require "shared/admin_controller_examples"

module Decidim::ParticipatoryProcesses::Admin
  describe MinorsSpaceController do
    routes { Decidim::ParticipatoryProcesses::AdminEngine.routes }

    include_context "when admin managing a participatory space"

    let!(:participatory_process) do
      create(
        :participatory_process,
        organization:
      )
    end

    it_behaves_like "controls the minor configuration" do
      let(:participatory_space) { participatory_process }
      let(:params) do
        { participatory_process_slug: participatory_process.slug }
      end
    end
  end
end
