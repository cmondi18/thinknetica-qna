require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/cmondi18/c4c1f91a73c03cf9dfb32792e856e025' }
  given(:second_gist_url) { 'https://gist.github.com/cmondi18/88d28a96b0add346cb73a3daa36302ce' }

  before do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Link name', with: 'My Gist'
    fill_in 'Url', with: gist_url
  end

  scenario 'User adds link when asks question' do
    click_on 'Ask'

    expect(page).to have_link 'My Gist', href: gist_url
  end

  scenario 'User adds two links when asks question', js: true do
    click_on 'add link'

    first(:field, 'Link name').fill_in with: 'My Second Gist'
    first(:field, 'Url').fill_in with: second_gist_url

    click_on 'Ask'

    expect(page).to have_link 'My Gist', href: gist_url
    expect(page).to have_link 'My Second Gist', href: second_gist_url
  end
end