# frozen_string_literal: true

require "spec_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-admin",
    files: {
      "/app/permissions/decidim/admin/permissions.rb" => "6c8fbf335c2483b9e6ab4f34f489b53a"
    }
  },
  {
    package: "decidim-core",
    files: {
      "/app/controllers/concerns/decidim/participatory_space_context.rb" => "b6a6b338d92eaaaf72b7b40f3a0da097",
      "/app/models/decidim/organization.rb" => "a72b9d9ef10aa06dbe5aef27c68d5c7a",
      "/app/models/decidim/static_page.rb" => "c7053dc82dfa2047f78573dfc1d9163d",
      "/app/views/decidim/devise/registrations/new.html.erb" => "b30423406afd43bb9af2c98d59d43632",
      "/app/views/layouts/decidim/_impersonation_warning.html.erb" => "a0e345165b4c88e9ab2eed2fb349c83b"
    }
  },
  {
    package: "decidim-verifications",
    files: {
      "/app/controllers/decidim/verifications/authorizations_controller.rb" => "1a08ea8ff4037b2bdc4a25833dad0078"
    }
  },
  {
    package: "decidim-system",
    files: {
      "/app/forms/decidim/system/register_organization_form.rb" => "7b4eab28179eb466b30383e357e2cc79",
      "/app/forms/decidim/system/update_organization_form.rb" => "1c66820ab01b12f4d934721152e014f0",
      "/app/commands/decidim/system/create_organization.rb" => "b7c49015ea3d682dbfd6d3c3f76e2d7a",
      "/app/commands/decidim/system/update_organization.rb" => "1fe0b3eb152fecdf63ef108743ae78e4",
      "/app/views/decidim/system/organizations/new.html.erb" => "4916cdb428d89de5afe60e279d64112f",
      "/app/views/decidim/system/organizations/edit.html.erb" => "01bff555e3d7680868fff210d3c393b2"
    }
  },
  {
    package: "decidim-kids",
    files: {
      "/app/controllers/concerns/decidim/kids/has_minor_activities_as_own.rb" => "05b8aa4b52972a0f85817fd4147b4021"
    }
  }
]

describe "Overriden files", type: :view do
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
