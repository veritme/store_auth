RSpec.feature 'Change email', type: :feature do
  background do
    allow_bypass_sign_in

    user = create(:user, email: 'old@spree.com', password: 'secret')
    log_in(email: user.email, password: 'secret')
    visit spree.edit_account_path
  end

  scenario 'work with correct password', js: true do
    fill_in 'user_email', with: 'tests@example.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Update'

    expect(page).to have_text 'Account updated'
    expect(page).to have_text 'tests@example.com'
  end
end
