# frozen_string_literal: true

module Decidim
  module Kids
    module AgeMethods
      def age_from_date(string_date)
        age_from_birthday(Date.parse(string_date))
      rescue TypeError, ::Date::Error
        nil
      end

      def age_from_birthday(birthday)
        ((Time.zone.now - birthday.to_time) / 1.year.seconds).floor
      end
    end
  end
end
