require 'rails_helper'

feature 'User can delete attachment files', %q{
  In order to delete wrong attachment files
  As an authenticated user
  I'd like to be able to delete attachment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, :with_file, user: user) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
    end

    scenario 'deletes his attachment' do
      visit question_path(question)
      click_on 'Delete attachment'

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario "deletes not his attachment" do
    end
  end

  context 'Unauthenticated user' do
    scenario "deletes attachment" do
      visit question_path(question)

      expect(page).to have_no_link('Delete answer')
    end
  end
end