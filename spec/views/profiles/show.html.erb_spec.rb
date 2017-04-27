# frozen_string_literal: true

require 'spec_helper'

describe 'profiles/show' do
  before(:each) do
    @profile = assign(:profile, stub_model(Profile,
                                           firstname: 'Firstname',
                                           lastname: 'Lastname',
                                           bio: 'MyText',
                                           website: 'Website',
                                           twitter: 'Twitter',
                                           facebook: 'Facebook',
                                           linkedin: 'Linkedin',
                                           google: 'Google',
                                           url: 'Url'))
  end

  it 'renders attributes in <p>' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Firstname/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Lastname/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Website/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Twitter/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Facebook/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Linkedin/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Google/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Url/)
  end
end
