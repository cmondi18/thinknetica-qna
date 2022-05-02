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
    given(:simple_link) { 'https://google.com' }
    given(:another_link) { 'https://ya.ru' }

    before do
      fill_in 'Body', with: 'text text text'
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: simple_link
    end

    scenario 'link when give an answer', js: true do
      click_on 'Submit answer'

      within '.answer' do
        expect(page).to have_link 'Google', href: simple_link
      end
    end

    scenario 'two links when give an answer', js: true do
      click_on 'add link'

      first(:field, 'Link name').fill_in with: 'Ya'
      first(:field, 'Url').fill_in with: another_link

      click_on 'Submit answer'

      within '.answer' do
        expect(page).to have_link 'Google', href: simple_link
        expect(page).to have_link 'Ya', href: another_link
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

  scenario 'User adds link with gist when give an answer', js: true do
    fill_in 'Body', with: 'text text text'
    fill_in 'Link name', with: 'My Gist'
    fill_in 'Url', with: 'https://gist.github.com/cmondi18/91ef047a566b358157223a54ac64c2ac'

    click_on 'Submit answer'

    within '.answer' do
      expect(page).to have_content 'thinknetica test gist'
    end
  end
end