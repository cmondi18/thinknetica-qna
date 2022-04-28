require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  describe 'User adds' do
    given(:gist_url) { 'https://gist.github.com/cmondi18/c4c1f91a73c03cf9dfb32792e856e025' }
    given(:second_gist_url) { 'https://gist.github.com/cmondi18/88d28a96b0add346cb73a3daa36302ce' }

    before do
      fill_in 'Body', with: 'text text text'
      fill_in 'Link name', with: 'My Gist'
      fill_in 'Url', with: gist_url
    end

    scenario 'link when give an answer', js: true do
      click_on 'Submit answer'

      within '.answer' do
        expect(page).to have_link 'My Gist', href: gist_url
      end
    end

    scenario 'two links when give an answer', js: true do
      click_on 'add link'

      first(:field, 'Link name').fill_in with: 'My Second Gist'
      first(:field, 'Url').fill_in with: second_gist_url

      click_on 'Submit answer'

      within '.answer' do
        expect(page).to have_link 'My Gist', href: gist_url
        expect(page).to have_link 'My Second Gist', href: second_gist_url
      end
    end
  end

  scenario 'User adds link with incorrect URL when give an answer', js: true do
    fill_in 'Body', with: 'text text text'
    fill_in 'Link name', with: 'My Gist'
    fill_in 'Url', with: 'wrongURL'

    click_on 'Submit answer'

    within '.answer-errors' do
      expect(page).to have_text 'Links url is not a valid HTTP URL'
    end
  end
end