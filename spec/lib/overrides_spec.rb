# frozen_string_literal: true

require "spec_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-admin",
    files: {
      "/app/permissions/decidim/admin/permissions.rb" => "0dc75c7d9901793c08a0c63962da7ebc"
    }
  },
  {
    package: "decidim-core",
    files: {
      "/app/controllers/concerns/decidim/participatory_space_context.rb" => "10c9d4655da79823cc54410636ee5442",
      "/app/models/decidim/organization.rb" => "e3d474ed92c0b8bb8911e6947a569845",
      "/app/models/decidim/static_page.rb" => "db2e6de50e80b41fab8d13640710597a",
      "/app/views/decidim/devise/registrations/new.html.erb" => "5f6f15330839fa55697c4e272767a090"
    }
  },
  {
    package: "decidim-verifications",
    files: {
      "/app/controllers/decidim/verifications/authorizations_controller.rb" => "4e518b2bc5dc7fe0ab3db985c1cd90ae",
      "/app/commands/decidim/verifications/authorize_user.rb" => "7c15085394f890d89e186ee7e0f5f72a"
    }
  },
  {
    package: "decidim-system",
    files: {
      "/app/forms/decidim/system/register_organization_form.rb" => "10667bf365ae7df36ed5d4628d1d4972",
      "/app/forms/decidim/system/update_organization_form.rb" => "b28ece5dbf3e227bc5b510886af567e2",
      "/app/commands/decidim/system/register_organization.rb" => "e1481a8528e4276804a7b9e531d5b25b",
      "/app/commands/decidim/system/update_organization.rb" => "10a082eede58856a73baccc19923b5b4",
      "/app/views/decidim/system/organizations/_advanced_settings.html.erb" => "5bd6514c89cd9d85790b57f38c115249"
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
    # rubocop:disable Rails/DynamicFindBy
    spec = ::Gem::Specification.find_by_name(item[:package])
    # rubocop:enable Rails/DynamicFindBy
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
