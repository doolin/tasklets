require 'spec_helper'

describe User do
  context 'validation' do
    context 'email' do
      it 'finds an invalid email address' do
        expect do
          create :user, email: 'foo'
        end.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
