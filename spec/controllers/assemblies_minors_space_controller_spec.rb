# frozen_string_literal: true

require "spec_helper"
require "shared/participatory_space_controller_examples"

# roles to check as allowed in a minor space
def allowed_roles
  {
    assembly_admin: :assembly,
    assembly_collaborator: :assembly,
    assembly_moderator: :assembly,
    assembly_evaluator: :assembly
  }
end

module Decidim::Assemblies
  describe AssembliesController do
    routes { Decidim::Assemblies::Engine.routes }

    let(:participatory_space) { assembly }
    let!(:assembly) do
      create(
        :assembly,
        organization:
      )
    end

    include_context "when participating in a minor's participatory space"

    it_behaves_like "access participatory space and components" do
      let(:params) do
        { slug: assembly.slug }
      end
    end
  end
end
