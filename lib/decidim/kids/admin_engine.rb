# frozen_string_literal: true

module Decidim
  module Kids
    # This is the engine that runs on the public interface of `Kids`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Kids::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      def load_seed
        nil
      end

      initializer "decidim_kids.participatory_spaces" do
        Decidim::Kids.participatory_spaces.each do |participatory_space|
          manifest = Decidim.find_participatory_space_manifest(participatory_space[:manifest])
          admin_menu = participatory_space[:admin_menu]
          admin_scope = participatory_space[:admin_scope]
          admin_slug = participatory_space[:admin_slug]
          next unless manifest && admin_menu && admin_scope

          engine = manifest.context(:admin).engine
          engine.routes.append do
            scope "#{admin_scope}:#{admin_slug}" do
              resources :minors_space
            end
          end

          Decidim.menu(admin_menu) do |menu|
            menu.add_item :minors_space,
                          I18n.t("minors_space.menu", scope: "decidim.kids.admin"),
                          engine.routes.url_helpers.minors_space_index_path(admin_slug => params[admin_slug] || params[:slug]),
                          position: 5.5,
                          active: :inclusive,
                          if: allowed_to?(:manage, :space_minors_configuration)
          end
        end
      end
    end
  end
end
