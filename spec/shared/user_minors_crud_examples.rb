# frozen_string_literal: true

shared_examples "creates minor accounts" do
  context "when the limit is not reached" do
    # check that accepting the terms and conditions is mandatory
    # check the age of the minor is within accepted range
    it "can add a minor" do
      # click on add minor account
      # fill the form
      # send the form
      # check that the database has a new user of type minor
    end
  end

  context "when the limit is reached" do
    it "cannot add a minor" do
      # when visiting the create new minor directly (without clicking on the button), user is rejected
    end
  end
end

shared_examples "updates minor accounts" do
  # can edit a minor
  # check database that the edition when through
end
