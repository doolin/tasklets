# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile do
  context 'validations' do
    subject(:profile) { build :profile }

    context 'firstname' do
      it 'does not valiate' do
        profile.firstname = 'a'
        expect(profile).not_to be_valid
      end
    end
  end
end
