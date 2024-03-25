# frozen_string_literal: true

require "spec_helper"
require "shared/admin_controller_examples"
require "shared/admin_participatory_space_examples"

describe "minors space" do
  include_context "with a minor's organization"

  let!(:assembly) do
    create(
      :assembly,
      organization:
    )
  end

  it_behaves_like "handles the minors configuration", "Assemblies" do
    let(:participatory_space) { assembly }
  end
end
