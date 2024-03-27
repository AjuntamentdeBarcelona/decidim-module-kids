# frozen_string_literal: true

# An example authorization handler used so that users can be verified against
# third party systems.
#
# This authorization is valid with any document ending in "X"
# It stores the birthday date so it can be used for untutelated minor's checks
class DummyAgeAuthorizationHandler < Decidim::AuthorizationHandler
  attribute :name_and_surname, String
  attribute :document_number, String
  attribute :birthday, Decidim::Attributes::LocalizedDate

  validates :document_number, :birthday, presence: true

  validate :valid_document_number

  def unique_id
    document_number
  end

  def metadata
    super.merge(document_number:, birthday:)
  end

  private

  def valid_document_number
    errors.add(:document_number, :invalid) unless document_number.to_s.end_with?("X")
  end
end
