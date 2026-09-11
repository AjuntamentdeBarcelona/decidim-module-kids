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
      "/app/controllers/concerns/decidim/participatory_space_context.rb" => "55b30d9318cb79be78a41cf60c369014",
      "/app/models/decidim/organization.rb" => "977969a742ef2ef7515395fcf6951df7",
      "/app/models/decidim/static_page.rb" => "c7053dc82dfa2047f78573dfc1d9163d",
      "/app/views/decidim/devise/shared/_tos_fields.html.erb" => "da1001a7139d8423228452d3ca481cef",
      "/app/views/layouts/decidim/_impersonation_warning.html.erb" => "d70885bf100da37004b2e11f77067b4e"
    }
  },
  {
    package: "decidim-verifications",
    files: {
      "/app/controllers/decidim/verifications/authorizations_controller.rb" => "41f6899dc28e9f987a0d437e5aa25daf"
    }
  },
  {
    package: "decidim-system",
    files: {
      "/app/forms/decidim/system/register_organization_form.rb" => "d68333a13882986bad8ffb2b2bc0aa95",
      "/app/forms/decidim/system/update_organization_form.rb" => "631ed13dc98e4bdfd39e60157d995672",
      "/app/commands/decidim/system/create_organization.rb" => "ad7faec3a21ced65054748dc2a4a119b",
      "/app/commands/decidim/system/update_organization.rb" => "551cb589c40db2a07e294f5dd3f500c0",
      "/app/views/decidim/system/organizations/new.html.erb" => "fe6aa2189e5e35d3f13bba42a02bf0f0",
      "/app/views/decidim/system/organizations/edit.html.erb" => "ad127f2ad863115794a249253db77866"
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
    item[:files].each do |file, signature|
      it "#{item[:package]}#{file} matches checksum" do
        gem_dir = Gem::Specification.find_by_name(item[:package]).gem_dir
        expect(md5("#{gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
