require 'rails_helper'

feature 'User can answer to question', %q{
  In order to add answer to community
  As an authenticated user
  I'd like to be able to answer to question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answers to question' do
      fill_in 'Body', with: 'answer answer!'
      click_on 'Submit answer'

      expect(page).to have_content 'answer answer!'
    end

    scenario 'answers to question with errors' do
      fill_in 'Body', with: ''
      click_on 'Submit answer'

      expect(page).to have_content "Can't submit answer with empty body"
    end
  end

  # TODO:
  #describe 'Unauthenticated user' do
  #  scenario 'tries to answer to question' do
  #    visit question_path(question)
  #
  #    expect(page).to_not have_content 'Body'
  #    expect(page).to_not have_selector(:link_or_button, 'Submit answer')
  #  end
  # end
end