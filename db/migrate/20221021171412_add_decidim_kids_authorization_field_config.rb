# frozen_string_literal: true

class AddDecidimKidsAuthorizationFieldConfig < ActiveRecord::Migration[6.1]
  def change
    change_table :decidim_kids_organization_configs do |t|
      t.string :minors_authorization
      t.string :tutors_authorization
    end
  end
end
