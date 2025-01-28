# frozen_string_literal: true

require "decidim/dev/common_rake"

def install_module(path)
  Dir.chdir(path) do
    system("bundle exec rake decidim_kids:install:migrations")
    system("bundle exec rake db:migrate")
    system("bundle exec rake decidim_kids:install:handlers")
  end
end

def change_file_content(path, file_path, old_content, new_content)
  Dir.chdir(path) do
    file_data = File.read(file_path)
    file_data.gsub!(old_content, new_content)
    File.open(file_path, "w") do |file|
      file.puts(file_data)
    end
  end
end

def seed_db(path)
  Dir.chdir(path) do
    system("bundle exec rake db:seed")
  end
end

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app" do
  ENV["RAILS_ENV"] = "test"
  install_module("spec/decidim_dummy_app")
  change_file_content("spec/decidim_dummy_app", "config/environments/test.rb", "config.cache_classes = true", "config.cache_classes = false")
end

desc "Generates a development app."
task :development_app do
  Bundler.with_original_env do
    generate_decidim_app(
      "development_app",
      "--app_name",
      "#{base_app_name}_development_app",
      "--path",
      "..",
      "--recreate_db",
      "--demo"
    )
  end

  install_module("development_app")
  seed_db("development_app")
end
