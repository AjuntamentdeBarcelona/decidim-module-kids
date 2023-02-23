# frozen_string_literal: true

require "spec_helper"
require "shared/admin_controller_examples"

module Decidim::Assemblies::Admin
  describe MinorsSpaceController, type: :controller do
    routes { Decidim::Assemblies::AdminEngine.routes }

    include_context "when admin managing a participatory space"

    let!(:assembly) do
      create(
        :assembly,
        organization: organization
      )
    end

    it_behaves_like "controls the minor configuration" do
      let(:participatory_space) { assembly }
      let(:params) do
        { assembly_slug: assembly.slug }
      end
    end
  end
end
