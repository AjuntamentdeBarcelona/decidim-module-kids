# frozen_string_literal: true

require "spec_helper"
require "shared/system_organization_examples"

describe "Creates an organization" do
  let(:admin) { create(:admin) }

  before do
    login_as admin, scope: :admin
    visit decidim_system.root_path
    click_on "Organizations"
    click_on "New"
  end

  it_behaves_like "creates organization"
end
