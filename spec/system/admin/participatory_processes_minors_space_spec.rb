# frozen_string_literal: true

require "spec_helper"
require "shared/admin_controller_examples"
require "shared/admin_participatory_space_examples"

describe "minors space" do
  include_context "with a minor's organization"

  let!(:participatory_process) do
    create(
      :participatory_process,
      organization:
    )
  end

  it_behaves_like "handles the minors configuration", "Processes" do
    let(:participatory_space) { participatory_process }
  end
end
