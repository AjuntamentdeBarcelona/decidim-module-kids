# frozen_string_literal: true

require "spec_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-admin",
    files: {
      "/app/permissions/decidim/admin/permissions.rb" => "f5b23cb4cf2d606b2cf70d01ba2fb591"
    }
  },
  {
    package: "decidim-core",
    files: {
      "/app/controllers/concerns/decidim/participatory_space_context.rb" => "4eb0c577edb6806684129420e0ae7bfa",
      "/app/models/decidim/organization.rb" => "04eaf4467a1e0d891251c5cedf71f5e4",
      "/app/models/decidim/static_page.rb" => "c7053dc82dfa2047f78573dfc1d9163d",
      "/app/views/decidim/devise/registrations/new.html.erb" => "e09cc2d8c7b5b770a7760813e18b1e49",
      "/app/views/layouts/decidim/_impersonation_warning.html.erb" => "b9d5fd40909a99246a9a4c09379a01a9"
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
      "/app/forms/decidim/system/register_organization_form.rb" => "10667bf365ae7df36ed5d4628d1d4972",
      "/app/forms/decidim/system/update_organization_form.rb" => "a1059e5a8745a2637703b6805deda53c",
      "/app/commands/decidim/system/register_organization.rb" => "a641c4f869a1cf460b41a7dec507706f",
      "/app/commands/decidim/system/update_organization.rb" => "1fe0b3eb152fecdf63ef108743ae78e4",
      "/app/views/decidim/system/organizations/new.html.erb" => "4916cdb428d89de5afe60e279d64112f",
      "/app/views/decidim/system/organizations/edit.html.erb" => "b3ca773290213f267c5d6f0083aca539"
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
