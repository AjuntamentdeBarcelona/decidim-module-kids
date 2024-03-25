# frozen_string_literal: true

require "spec_helper"
require "shared/participatory_space_controller_examples"

# roles to check as allowed in a minor space
def allowed_roles
  {
    process_admin: :participatory_process,
    process_collaborator: :participatory_process,
    process_moderator: :participatory_process,
    process_valuator: :participatory_process
  }
end

module Decidim::ParticipatoryProcesses
  describe ParticipatoryProcessesController do
    routes { Decidim::ParticipatoryProcesses::Engine.routes }

    let(:participatory_space) { participatory_process }
    let!(:participatory_process) do
      create(
        :participatory_process,
        organization:
      )
    end

    include_context "when participating in a minor's participatory space"

    it_behaves_like "access participatory space and components" do
      let(:params) do
        { slug: participatory_process.slug }
      end
    end
  end
end
