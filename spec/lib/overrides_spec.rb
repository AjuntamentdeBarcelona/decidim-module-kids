# frozen_string_literal: true

require "spec_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/models/decidim/organization.rb" => "e0b67b906f0ad3db84226914f07a05e7",
      "/app/models/decidim/static_page.rb" => "23b8d77f1893d11af189001cbaa008c8",
      "/app/views/decidim/devise/registrations/new.html.erb" => "593710b9c75fc90f1322871f231f0b5f"
    }
  },
  {
    package: "decidim-system",
    files: {
      "/app/forms/decidim/system/register_organization_form.rb" => "10667bf365ae7df36ed5d4628d1d4972",
      "/app/forms/decidim/system/update_organization_form.rb" => "8da97bdb563fd2d69de3895d40290058",
      "/app/commands/decidim/system/register_organization.rb" => "e1481a8528e4276804a7b9e531d5b25b",
      "/app/commands/decidim/system/update_organization.rb" => "10a082eede58856a73baccc19923b5b4",
      "/app/views/decidim/system/organizations/new.html.erb" => "ef9277c31e87f864e911a05d7ad0a333",
      "/app/views/decidim/system/organizations/edit.html.erb" => "a5fbf0df2106009878cbca6e36472cae"
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
