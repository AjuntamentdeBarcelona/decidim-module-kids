# frozen_string_literal: true

require "spec_helper"

# We make sure that the checksum of the file overridden is the same
# as the expected. If this test fails, it means that the overridden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-admin",
    files: {
      "/app/permissions/decidim/admin/permissions.rb" => "cba13178b0ea6f612c70dd83916ead29"
    }
  },
  {
    package: "decidim-core",
    files: {
      "/app/controllers/concerns/decidim/participatory_space_context.rb" => "fbdc2962e9167d3e2155be07ff2a1b8f",
      "/app/models/decidim/organization.rb" => "977969a742ef2ef7515395fcf6951df7",
      "/app/models/decidim/static_page.rb" => "c7053dc82dfa2047f78573dfc1d9163d",
      "/app/views/decidim/devise/shared/_tos_fields.html.erb" => "02de107df16ac44b0f10688dbea299f6",
      "/app/views/layouts/decidim/_impersonation_warning.html.erb" => "d70885bf100da37004b2e11f77067b4e"
    }
  },
  {
    package: "decidim-verifications",
    files: {
      "/app/controllers/decidim/verifications/authorizations_controller.rb" => "cfcb7af376bda64dbd3e2d5db87c6859"
    }
  },
  {
    package: "decidim-system",
    files: {
      "/app/forms/decidim/system/register_organization_form.rb" => "7b4eab28179eb466b30383e357e2cc79",
      "/app/forms/decidim/system/update_organization_form.rb" => "51e2fb7773d646652231133a12fd8ff3",
      "/app/commands/decidim/system/create_organization.rb" => "b8b20c82fbe8dd4ac412ec3f41b8f3cc",
      "/app/commands/decidim/system/update_organization.rb" => "58f21a2eb8f6ee9570864c8e26397d5a",
      "/app/views/decidim/system/organizations/new.html.erb" => "4916cdb428d89de5afe60e279d64112f",
      "/app/views/decidim/system/organizations/edit.html.erb" => "6428bfb2edcdd36fa01f702f3dbc2f57"
    }
  },
  {
    package: "decidim-kids",
    files: {
      "/app/controllers/concerns/decidim/kids/has_minor_activities_as_own.rb" => "05b8aa4b52972a0f85817fd4147b4021"
    }
  }
]

describe "Overridden files", type: :view do
  checksums.each do |item|
    spec = Gem::Specification.find_by_name(item[:package])
    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
