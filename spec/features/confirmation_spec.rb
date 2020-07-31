require 'spec_helper'

RSpec.feature 'Confirmation', type: :feature, reload_user: true do
  before do
    set_confirmable_option(true)
    Spree::UserMailer.stub(:confirmation_instructions).and_return(double(deliver: true))
  end

  after(:each) { set_confirmable_option(false) }

  background do
    ActionMailer::Base.default_url_options[:host] = 'http://example.com'
  end

  scenario 'create a new user' do
    visit spree.signup_path

    fill_in 'Email', with: 'email@person.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password Confirmation', with: 'password'
    click_button 'Sign Up'

    expect(page).to have_text I18n.t('devise.user_registrations.signed_up_but_unconfirmed')
    expect(Spree.user_class.last.confirmed?).to be(false)
  end
end
