require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/cmondi18/c4c1f91a73c03cf9dfb32792e856e025' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text text'
    fill_in 'Link name', with: 'My Gist'
    fill_in 'Url', with: gist_url

    click_on 'Submit answer'

    within '.answer' do
      expect(page).to have_link 'My Gist', href: gist_url
    end
  end
end